import 'package:MegaObra/crud/compact/project.dart';
import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/screens/manager/create/activity.dart';
import 'package:MegaObra/widgets/buttons/slider.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/screens/manager/edit/project.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/list/simple/employee.dart';
import 'package:MegaObra/widgets/list/simple/activity.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/models/compact/project.dart';
import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/models/user.dart';

class AdministratorProjectViewer extends StatefulWidget {
  ProjectCompactView projectCompactView;

  AdministratorProjectViewer({super.key, required this.projectCompactView});

  @override
  State<AdministratorProjectViewer> createState() => _AdministratorProjectViewerState();
}

class _AdministratorProjectViewerState extends State<AdministratorProjectViewer> {
  int _viewIndex = 0;
  List<Activity> _loadedActivities = [];
  List<Activity> _loadedRainActivities = [];

  void collectProjectActivities() async {
    if (!mounted) {
      return;
    }
    try {
      List<Activity>? activities = await getProjectActivity(context, widget.projectCompactView.project.id);
      List<Activity>? activities_rain = await getProjectRain(context, widget.projectCompactView.project.id);
      if (activities != null && mounted) {
        setState(() {
          _loadedActivities = activities;
          _loadedRainActivities = activities_rain;
        });
      }
    } catch (e) {
      print("Error: ${e}");
    }
  }

  @override
  void initState() {
    super.initState();
    collectProjectActivities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.projectCompactView;
    const double megaobraInfoMaxWidth = 500.0;

    void viewUserNavigator(int userId) async {
      if (!mounted) {
        return;
      }
      User? collectedUser = await getUserById(context, userId);
      if (collectedUser != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdministratorUserViewer(
                user: collectedUser,
                spectate: false,
              ),
            ),
          );
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCollectingUser,
        );
      }
    }

    void showPermissionErrorMessage() {
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.permissionError,
          text: AppLocalizations.of(context)!.onlyUsersWithHigherPermissionCanModifyProjectAttributes,
        );
      }
    }

    void showProjectHasAlreadyFinishedMessage() {
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.projectCompleted,
          text: AppLocalizations.of(context)!.itIsNotPossibleToModifyAttributesOfProjectThatHasAlreadyBeenCompleted,
        );
      }
    }

    Widget getSelectedView() {
      switch (_viewIndex) {
        case 0:
          return Container(
            child: MegaObraSimpleActivityListWidget(
              maxStringSize: 58,
              label: AppLocalizations.of(context)!.activities,
              activities: _loadedActivities,
              ableToNavigate: true,
              emptyLabel: AppLocalizations.of(context)!.noActivitiesFound,
              forceHighPermission: (getLoggedUser()?.id == widget.projectCompactView.responsible.id),
              showCreateButton: true,
              showCloneButton: true,
              projectToAssociate: widget.projectCompactView.project.id,
              filterRestrictionsByProjectId: widget.projectCompactView.project.id,
            ),
          );
        case 2:
          return SizedBox(
            child: MegaObraSimpleActivityListWidget(
              maxStringSize: 58,
              label: AppLocalizations.of(context)!.inCaseOfRain,
              activities: _loadedRainActivities,
              ableToNavigate: true,
              emptyLabel: AppLocalizations.of(context)!.noActivitiesFound,
            ),
          );
        case 1:
          return MegaObraSimpleEmployeeListWidget(
            label: AppLocalizations.of(context)!.moderators,
            employees: project.employees,
            ableToNavigate: true,
          );
        default:
          return MegaObraSimpleEmployeeListWidget(
            label: AppLocalizations.of(context)!.moderators,
            employees: project.employees,
            ableToNavigate: true,
          );
      }
    }

    void reloadCompactProject() async {
      ProjectCompactView? collected_project = await getCompactProjectById(
        context,
        project.project.id,
      );
      if (mounted && collected_project != null) {
        setState(() {
          widget.projectCompactView = collected_project;
        });
      }
    }

    void finishCurrentProject() async {
      if (widget.projectCompactView.project.deactivation_date != null) {
        return;
      }
      print("PERMISSION ID: ${getLoggedUser()?.permission_id}");
      if (![1, 2].contains(getLoggedUser()?.permission_id) && getLoggedUser()?.id != project.responsible.id) {
        showPermissionErrorMessage();
        return;
      }
      finishProject(context, widget.projectCompactView.project.id);
      reloadCompactProject();
    }

    void navigateToEditProject() {
      if (project.project.deactivation_date != null) {
        showProjectHasAlreadyFinishedMessage();
        return;
      }
      if (!mounted) {
        return;
      } else {
        [1, 2].contains(getLoggedUser()?.permission_id) || getLoggedUser()?.id == project.responsible.id
            ? mounted
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProjectScreen(
                        project: widget.projectCompactView.project,
                        startDate: widget.projectCompactView.project.start_date,
                        deadlineDate: widget.projectCompactView.project.deadline_date,
                        responsible: widget.projectCompactView.responsible.name,
                      ),
                    ),
                  )
                : null
            : showPermissionErrorMessage();
      }
    }

    void rotateView() {
      setState(() {
        if (_viewIndex == 2) {
          _viewIndex = 0;
        } else {
          _viewIndex += 1;
        }
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const MegaObraNavigatorPopButton(),
                  MegaObraRefreshButton(onPressed: () {
                    reloadCompactProject();
                    collectProjectActivities();
                  }),
                ],
              ),
              const Spacer(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.projectCompactView.project.deactivation_date == null ? Icons.featured_play_list : Icons.done_all,
                    color: megaobraIconColor(),
                    size: 80,
                  ),
                  const SizedBox(width: 20),
                  MegaObraDefaultText(
                    size: 50,
                    text: formatStringByLength(
                      widget.projectCompactView.project.title,
                      24,
                    ),
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              const SizedBox(height: 5),
              if (widget.projectCompactView.project.title.length > 24)
                MegaObraTinyText(
                  text: "${AppLocalizations.of(context)!.fullTitle}: ${formatStringByLength(
                    widget.projectCompactView.project.title,
                    128,
                  )}",
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Opacity(
                            opacity: _viewIndex == 0 ? 1.0 : 0.3,
                            child: SizedBox(
                              width: 70,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 38,
                                    child: Text(
                                      AppLocalizations.of(context)!.activitiesReallyAbbreviatedAndUpperCased,
                                      style: TextStyle(
                                        color: megaobraIconColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.lens,
                                    color: megaobraIconColor(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Opacity(
                            opacity: _viewIndex == 1 ? 1.0 : 0.3,
                            child: SizedBox(
                              width: 70,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 38,
                                    child: Text(
                                      AppLocalizations.of(context)!.moderatorsReallyAbbreviatedAndUpperCased,
                                      style: TextStyle(
                                        color: megaobraIconColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.lens,
                                    color: megaobraIconColor(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Opacity(
                            opacity: _viewIndex == 2 ? 1.0 : 0.3,
                            child: SizedBox(
                              width: 70,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 38,
                                    child: Text(
                                      AppLocalizations.of(context)!.rainReallyAbbreviatedAndUpperCased,
                                      style: TextStyle(
                                        color: megaobraIconColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.lens,
                                    color: megaobraIconColor(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          IconButton(
                            onPressed: () => {
                              if (mounted)
                                {
                                  rotateView(),
                                }
                            },
                            icon: Icon(
                              Icons.loop,
                              color: megaobraIconColor(),
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 345,
                        width: 345,
                        child: getSelectedView(),
                      ),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    children: [
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.averagePrice,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: "R\$ ${widget.projectCompactView.cost}",
                      ),
                      const SizedBox(height: 10),
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.created,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: formatDateTime(
                          dateTime: project.project.creation_date,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.deadline,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: formatDateTime(
                          dateTime: project.project.deadline_date,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.creator,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: formatStringByLength(project.creator.name, 20),
                      ),
                      const SizedBox(height: 10),
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.responsible,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: formatStringByLength(project.responsible.name, 20),
                      ),
                      const SizedBox(height: 10),
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.done,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: project.project.deactivation_date == null
                            ? AppLocalizations.of(context)!.inProgress
                            : AppLocalizations.of(context)!.yes,
                      ),
                      const SizedBox(height: 10),
                      MegaObraInformationContainer(
                        containerWidth: 140,
                        containerHeight: 40,
                        text: AppLocalizations.of(context)!.completionDate,
                        maxWidth: megaobraInfoMaxWidth,
                        sideText: project.project.deactivation_date == null
                            ? AppLocalizations.of(context)!.notCompleted
                            : formatDateTime(
                                dateTime: project.project.deactivation_date,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Opacity(
                opacity: widget.projectCompactView.project.deactivation_date == null ? 1.0 : 0.4,
                child: MegaObraButton(
                  icon: widget.projectCompactView.project.deactivation_date == null ? Icons.edit : Icons.lock,
                  width: 400,
                  height: 35,
                  text: AppLocalizations.of(context)!.modifyProjectAttributes,
                  padding: const EdgeInsets.all(8.0),
                  function: () => navigateToEditProject(),
                ),
              ),
              MegaObraButton(
                icon: Icons.manage_accounts,
                width: 400,
                height: 35,
                text: AppLocalizations.of(context)!.creatorInformation,
                padding: const EdgeInsets.all(8.0),
                function: () => viewUserNavigator(project.creator.id),
              ),
              MegaObraButton(
                icon: Icons.person_search,
                width: 400,
                height: 35,
                text: AppLocalizations.of(context)!.responsibleInformation,
                padding: const EdgeInsets.all(8.0),
                function: () => viewUserNavigator(project.responsible.id),
              ),
              Opacity(
                opacity: widget.projectCompactView.project.deactivation_date == null ? 1.0 : 0.4,
                child: MegaObraButton(
                  icon: widget.projectCompactView.project.deactivation_date == null ? Icons.done_all : Icons.lock,
                  width: 400,
                  height: 35,
                  text: widget.projectCompactView.project.deactivation_date == null
                      ? AppLocalizations.of(context)!.markDone
                      : AppLocalizations.of(context)!.done,
                  padding: const EdgeInsets.all(8.0),
                  function: () => {
                    if (widget.projectCompactView.project.deactivation_date == null)
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: megaobraNeutralOpaqueText(),
                          child: MegaObraSliderConfirmWidget(
                            question: AppLocalizations.of(context)!.doYouWantToFinishThisProject,
                            onConfirm: () {
                              Navigator.of(context).pop();
                              finishCurrentProject();
                            },
                          ),
                        ),
                      ),
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
