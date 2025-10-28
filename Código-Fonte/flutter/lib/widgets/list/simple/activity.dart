import 'package:MegaObra/screens/manager/create/activity.dart';
import 'package:MegaObra/screens/manager/view/gantt_activity.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/screens/manager/view/activity.dart';
import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraSimpleActivityListWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<Activity> activities;
  final bool showUndone;
  final int maxStringSize;
  bool ableToNavigate;
  bool forceHighPermission;
  bool showCreateButton;
  int? projectToAssociate;
  int? filterRestrictionsByProjectId;
  bool showCloneButton;
  MegaObraSimpleActivityListWidget({
    super.key,
    required this.label,
    required this.activities,
    required this.ableToNavigate,
    this.emptyLabel = "?",
    this.showUndone = true,
    this.maxStringSize = 14,
    this.forceHighPermission = false,
    this.showCreateButton = false,
    this.projectToAssociate,
    this.showCloneButton = false,
    this.filterRestrictionsByProjectId,
  });

  @override
  MegaObraSimpleActivityListWidgetState createState() => MegaObraSimpleActivityListWidgetState();
}

class MegaObraSimpleActivityListWidgetState extends State<MegaObraSimpleActivityListWidget> {
  @override
  void initState() {
    super.initState();
  }

  String formatActivityDescription(String name) {
    return name.length > widget.maxStringSize ? '${name.substring(0, widget.maxStringSize)}...' : name;
  }

  Future<Location?> getLocation(int location_id) async {
    if (mounted) {
      return getLocationById(context, location_id);
    }
  }

  void viewActivityNavigator(Activity activity, int location_id) async {
    if (!mounted) {
      return;
    }
    setState(() {
      widget.ableToNavigate = false;
    });
    Location? location = await getLocation(location_id);
    if (location != null) {
      if (mounted) {
        setState(() {
          widget.ableToNavigate = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministratorActivityViewer(
              activity: activity,
              activityLocation: location,
              hideButtons: false,
              forceHighPermission: widget.forceHighPermission,
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
    if (mounted) {
      setState(() {
        widget.ableToNavigate = true;
      });
    }
  }

  IconData getIcon(bool done) {
    if (done) {
      return Icons.check;
    } else {
      return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: megaobraListBackgroundColors(),
          begin: megaobraListBackgroundGradientdStart(),
          end: megaobraListBackgroundGradientdEnd(),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.showCreateButton,
                child: IconButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateActivityScreen(
                            projectId: widget.projectToAssociate,
                            filterRestrictionsByProjectId: widget.filterRestrictionsByProjectId,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: megaobraNeutralText(),
                ),
              ),
              const Spacer(),
              widget.activities.isEmpty
                  ? Opacity(
                      opacity: 0.3,
                      child: Icon(
                        Icons.power_input,
                        color: megaobraIconColor(),
                      ),
                    )
                  : IconButton(
                      onPressed: () => {
                        if (mounted)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GanttChartFromActivities(
                                  activities: widget.activities,
                                ),
                              ),
                            ),
                          },
                      },
                      icon: Icon(
                        Icons.power_input,
                        color: megaobraIconColor(),
                      ),
                    ),
            ],
          ),
          Divider(
            color: megaobraListDivider(),
            thickness: 2.0,
          ),
          Expanded(
            child: widget.activities.isEmpty
                ? Center(
                    child: Text(
                      widget.emptyLabel,
                      style: TextStyle(
                        color: megaobraNeutralText(),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.activities.length,
                    itemBuilder: (context, index) {
                      final activity = widget.activities[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: megaobraListDivider()),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                getIcon(activity.done),
                                color: megaobraIconColor(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  formatActivityDescription(activity.description),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: megaobraNeutralText(),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.showCloneButton,
                              child: IconButton(
                                onPressed: () => {
                                  if (widget.showCloneButton && mounted)
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateActivityScreen(
                                            referenceActivity: activity,
                                          ),
                                        ),
                                      ),
                                    }
                                },
                                icon: Icon(
                                  Icons.theater_comedy_sharp,
                                  color: megaobraIconColor(),
                                  size: 20,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: widget.ableToNavigate ? 1.0 : 0.3,
                              child: IconButton(
                                onPressed: () => {
                                  if (widget.ableToNavigate && mounted)
                                    {
                                      viewActivityNavigator(
                                        activity,
                                        activity.location_id,
                                      ),
                                    }
                                },
                                icon: Icon(
                                  Icons.format_list_bulleted,
                                  color: megaobraIconColor(),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
