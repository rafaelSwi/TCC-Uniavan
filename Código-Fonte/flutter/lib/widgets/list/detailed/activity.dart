import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/screens/manager/view/activity.dart';
import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/location.dart';
import 'package:flutter/services.dart';

class MegaObraDetailedActivityListWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<Activity> activities;
  final bool showUndone;
  final void Function()? addButtonFunction;

  const MegaObraDetailedActivityListWidget({
    super.key,
    required this.label,
    required this.activities,
    this.emptyLabel = "?",
    this.showUndone = true,
    required this.addButtonFunction,
  });

  @override
  MegaObraDetailedActivityListWidgetState createState() => MegaObraDetailedActivityListWidgetState();
}

class MegaObraDetailedActivityListWidgetState extends State<MegaObraDetailedActivityListWidget> {
  bool showLiterallyAll = false;
  bool ableToNavigate = true;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  void showPermissionErrorMessage(BuildContext context) {
    if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.permissionError,
        text: AppLocalizations.of(context)!.notPossibleToCreateActivity,
      );
    }
  }

  String formatActivityDescription(String name) {
    int size = 70;
    return name.length > size ? '${name.substring(0, size)}.' : name;
  }

  Future<Location?> getLocation(int location_id) async {
    if (mounted) {
      return getLocationById(context, location_id);
    }
  }

  void viewActivityNavigator(Activity activity, int location_id) async {
    setState(() {
      ableToNavigate = false;
    });
    Location? location = await getLocation(location_id);
    if (location != null && mounted) {
      setState(() {
        ableToNavigate = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdministratorActivityViewer(
            activity: activity,
            activityLocation: location,
            hideButtons: false,
            forceHighPermission: false,
          ),
        ),
      );
    } else if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.error,
        text: AppLocalizations.of(context)!.errorOpeningActivity,
      );
    }
    if (mounted) {
      setState(() {
        ableToNavigate = true;
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

  void applySearch() {
    if (mounted) {
      setState(() {
        searchQuery = searchController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> filteredActivities = widget.activities
        .where((activity) =>
            (showLiterallyAll || !activity.done) &&
            (searchQuery.isEmpty || activity.description.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();

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
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            applySearch();
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: megaobraNeutralOpaqueText(),
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchByDescription,
                          hintStyle: TextStyle(color: megaobraNeutralOpaqueText()),
                          filled: true,
                          fillColor: Colors.transparent,
                          icon: Icon(
                            Icons.search,
                            color: megaobraNeutralOpaqueText(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: applySearch,
                    icon: const Icon(Icons.search),
                    color: megaobraIconColor(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: [1, 2].contains(getLoggedUser()?.permission_id)
                      ? (mounted ? widget.addButtonFunction : null)
                      : () => showPermissionErrorMessage(context),
                  icon: Icon(
                    Icons.add,
                    color: megaobraNeutralText(),
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
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.showCompletedActivities,
                      style: TextStyle(color: megaobraNeutralText(), fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    MegaObraSwitch(
                      value: showLiterallyAll,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            showLiterallyAll = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: megaobraListDivider(),
              thickness: 2.0,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                  child: Icon(
                    Icons.info_outline,
                    color: megaobraIconColor(),
                    size: 20,
                  ),
                ),
                Container(
                  width: 400,
                  padding: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                  child: Text(
                    "${AppLocalizations.of(context)!.description} / ${AppLocalizations.of(context)!.startDate} / ${AppLocalizations.of(context)!.deadlineDate}",
                    style: TextStyle(
                      color: megaobraNeutralText(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: filteredActivities.isEmpty
                  ? Center(
                      child: Text(
                        widget.emptyLabel,
                        style: TextStyle(
                          color: megaobraNeutralText(),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
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
                                    formatActivityDescription(
                                      activity.description,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: megaobraNeutralText(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              MegaObraDefaultText(
                                text:
                                    "${formatDateTime(dateTime: activity.start_date, nullText: "...")} > ${formatDateTime(dateTime: activity.deadline_date, nullText: "...")}",
                                size: 20,
                              ),
                              Opacity(
                                opacity: ableToNavigate ? 1.0 : 0.5,
                                child: IconButton(
                                  onPressed: () => {
                                    if (mounted && ableToNavigate)
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
      ),
    );
  }
}
