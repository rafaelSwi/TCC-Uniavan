import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/screens/manager/view/activity.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';

class ActivitySelectionPage extends StatefulWidget {
  final List<int> selectedActivityIds;
  final Function(List<int>) onApply;
  final int? filterByProject;

  const ActivitySelectionPage({
    Key? key,
    required this.selectedActivityIds,
    required this.onApply,
    this.filterByProject,
  }) : super(key: key);

  @override
  _ActivitySelectionPageState createState() => _ActivitySelectionPageState();
}

class _ActivitySelectionPageState extends State<ActivitySelectionPage> {
  List<Activity> _loadedActivities = [];
  List<Activity> _filteredActivities = [];
  Set<int> _markedActivitiesIds = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _markedActivitiesIds = widget.selectedActivityIds.toSet();
    _loadActivities();
  }

  void _loadActivities() async {
    if (mounted) {
      List<Activity> resultActivities;
      print("widget.filterByProject: ${widget.filterByProject}");
      if (widget.filterByProject != null) {
        resultActivities = await getProjectActivity(context, widget.filterByProject!);
      } else {
        resultActivities = await getAssociatedActivities(context, true);
      }
      if (mounted) {
        setState(() {
          _loadedActivities = resultActivities;
          _filteredActivities = resultActivities;
        });
      }
    }
  }

  Future<Location?> getLocation(int location_id) async {
    return getLocationById(context, location_id);
  }

  void _toggleActivitySelection(int activityId) {
    if (mounted) {
      setState(() {
        if (_markedActivitiesIds.contains(activityId)) {
          _markedActivitiesIds.remove(activityId);
        } else {
          _markedActivitiesIds.add(activityId);
        }
      });
    }
  }

  void viewActivityNavigator(Activity activity, int location_id) async {
    Location? location = await getLocation(location_id);
    if (location != null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministratorActivityViewer(
              activity: activity,
              activityLocation: location,
              hideButtons: true,
              forceHighPermission: false,
            ),
          ),
        );
      }
    } else if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.error,
        text: AppLocalizations.of(context)!.errorOpeningActivity,
      );
    }
  }

  void _filterActivities(String query) {
    if (!mounted) {
      return;
    }
    setState(() {
      _searchQuery = query;
      _filteredActivities =
          _loadedActivities.where((act) => act.description.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: megaobraNeutralText(),
          ),
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        ),
        title: Row(
          children: [
            Icon(Icons.search, color: megaobraNeutralOpaqueText()),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: _filterActivities,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchByDescription,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: megaobraNeutralOpaqueText()),
                ),
                style: TextStyle(color: megaobraNeutralOpaqueText()),
              ),
            ),
          ],
        ),
        backgroundColor: megaobraSwitchBackground(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _filteredActivities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = _filteredActivities[index];
                        final isMarked = _markedActivitiesIds.contains(activity.id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: GestureDetector(
                            onTap: () => _toggleActivitySelection(activity.id),
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                Checkbox(
                                  value: isMarked,
                                  onChanged: (value) {
                                    _toggleActivitySelection(activity.id);
                                  },
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MegaObraDefaultText(
                                        text: formatStringByLength(activity.description, 68),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  color: megaobraIconColor(),
                                  onPressed: () => {
                                    viewActivityNavigator(
                                      activity,
                                      activity.location_id,
                                    )
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MegaObraInformationContainer(
                text: AppLocalizations.of(context)!.selectedPlural,
                containerWidth: 270,
                maxWidth: 320,
                sideText: _markedActivitiesIds.length.toString(),
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onApply(_markedActivitiesIds.toList());
          if (mounted) {
            Navigator.pop(context);
          }
        },
        backgroundColor: megaobraButtonBackground(),
        foregroundColor: megaobraColoredText(),
        child: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        ),
      ),
    );
  }
}
