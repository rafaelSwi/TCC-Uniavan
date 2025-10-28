import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/screens/manager/view/activity.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraActivitySelector extends StatefulWidget {
  final List<Activity> activities;
  final void Function(List<Activity>) onActivitySelected;
  final bool showSearchBar;
  final String searchBarLabel;

  const MegaObraActivitySelector({
    super.key,
    required this.activities,
    required this.onActivitySelected,
    this.showSearchBar = false,
    required this.searchBarLabel,
  });

  @override
  _MegaObraActivitySelectorState createState() => _MegaObraActivitySelectorState();
}

class _MegaObraActivitySelectorState extends State<MegaObraActivitySelector> {
  List<Activity> selectedActivities = [];
  List<Activity> displayedActivities = [];

  @override
  void initState() {
    super.initState();
    displayedActivities = widget.activities;
  }

  void toggleSelection(Activity activity) {
    if (mounted) {
      setState(() {
        if (selectedActivities.contains(activity)) {
          selectedActivities.remove(activity);
        } else {
          selectedActivities.add(activity);
        }
        widget.onActivitySelected(selectedActivities);
      });
    }
  }

  Future<Location?> getLocation(int location_id) async {
    if (mounted) {
      return getLocationById(context, location_id);
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

  void searchActivities(String query) {
    if (mounted) {
      setState(() {
        if (query.isEmpty) {
          displayedActivities = widget.activities;
        } else {
          displayedActivities =
              widget.activities.where((activity) => activity.description.toLowerCase().contains(query.toLowerCase())).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showSearchBar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: searchActivities,
              decoration: InputDecoration(
                labelText: widget.searchBarLabel,
                labelStyle: TextStyle(color: megaobraNeutralText()),
                prefixIcon: Icon(Icons.search),
                iconColor: megaobraIconColor(),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: megaobraNeutralText()),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: megaobraNeutralText()),
                ),
              ),
            ),
          ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: megaobraNeutralText()),
            ),
            child: ListView.builder(
              itemCount: displayedActivities.length,
              itemBuilder: (context, index) {
                final activity = displayedActivities[index];
                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(
                        formatStringByLength(activity.description, 42),
                        style: TextStyle(
                          color: megaobraNeutralText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: selectedActivities.contains(activity),
                      onChanged: (bool? selected) {
                        toggleSelection(activity);
                      },
                      activeColor: megaobraNeutralText(),
                      checkColor: megaobraColoredText(),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          megaobraButtonBackground(),
                        ),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                      ),
                      onPressed: () => viewActivityNavigator(
                        activity,
                        activity.location_id,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.details,
                        style: TextStyle(
                          color: megaobraColoredText(),
                        ),
                      ),
                    ),
                    Divider(
                      color: megaobraListDivider(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
