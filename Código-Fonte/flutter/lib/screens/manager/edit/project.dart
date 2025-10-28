import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/dropdown/employee.dart';
import 'package:MegaObra/widgets/selector/activity.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/selector/user.dart';
import 'package:MegaObra/widgets/datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/user.dart';

class EditProjectScreen extends StatefulWidget {
  Project project;
  String responsible;
  DateTime startDate;
  DateTime deadlineDate;
  EditProjectScreen({
    super.key,
    required this.project,
    required this.responsible,
    required this.startDate,
    required this.deadlineDate,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final double megaobraInfoMaxWidth = 220.0;
  DateTime? _startDateSelector;
  DateTime? _deadlineSelector;
  var _selectedResponsible = const User(
    id: 0,
    name: "",
    cpf: "",
    role_id: 0,
    schedule_id: 0,
    permission_id: 0,
  );
  List<Activity> _multipleActivity = [];
  List<User> _multipleEmployee = [];
  List<Activity> _multipleRain = [];

  List<Activity> _loadedActivities = [];
  List<Activity> _loadedRainActivities = [];
  List<User> _loadedUsers = [];

  int selector = 0;

  void _handleStartDateSelector(DateTime date) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _startDateSelector = date;
        });
      });
    }
  }

  void _handleDeadlineSelector(DateTime date) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _deadlineSelector = date;
        });
      });
    }
  }

  void _handleEmployeesSelector(List<User> users) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _multipleEmployee = users;
        });
      });
    }
  }

  void _handleActivitiesSelector(List<Activity> activities) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _multipleActivity = activities;
        });
      });
    }
  }

  void _handleActivitiesRainSelector(List<Activity> activities) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _multipleRain = activities;
        });
      });
    }
  }

  void _handleResponsibleSelector(User user) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _selectedResponsible = user;
        });
      });
    }
  }

  void loadUsers() async {
    if (!mounted) {
      return;
    }
    var result_users = await getAllUsers(context);
    var result_act = await getAssociatedActivities(context, true);
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _loadedUsers = result_users;
          _loadedActivities = result_act;
          _loadedRainActivities = result_act;
        });
      });
    }
  }

  List<int> convertActivitiesIntoIntList(List<Activity> activity_list) {
    List<int> return_list = [];
    for (int i = 0; i < activity_list.length; i++) {
      return_list.add(activity_list[i].id);
    }
    return return_list;
  }

  void tryToEditProject(
    BuildContext context,
    ProjectEdit projectEdit,
  ) async {
    try {
      await editProject(context, projectEdit);
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.project,
          text: AppLocalizations.of(context)!.requestToUpdateProject,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to edit a project: $e");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingProject,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  ProjectEdit generateProjectEdit() {
    return ProjectEdit(
      id: widget.project.id,
      title: widget.project.title,
      start_date: _startDateSelector == null ? widget.startDate : _startDateSelector!,
      deadline_date: _deadlineSelector == null ? widget.deadlineDate : _deadlineSelector!,
      responsible_id: _selectedResponsible.id == 0 ? widget.project.responsible_id : _selectedResponsible.id,
      rain: _multipleRain.map((rain) => rain.id).toList(),
      employee: _multipleEmployee.map((emp) => emp.id).toList(),
      activity: _multipleActivity.map((act) => act.id).toList(),
    );
  }

  int getSelectorTab(current_tab, bool end) {
    if (current_tab == 2) {
      if (end) {
        return current_tab;
      } else {
        return 0;
      }
    } else {
      return (current_tab + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MegaObraNavigatorPopButton(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: megaobraIconColor(),
                  size: 40,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.updateProject,
                  size: 40,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            MegaObraTinyText(
              text: AppLocalizations.of(context)!.activitiesAndModeratorsWillBeAddedToTheExistingProject,
            ),
            MegaObraTinyText(
              text: AppLocalizations.of(context)!.notPossibleToRemoveActivitiesOrModeratorsFromCreatedProjects,
            ),
            const SizedBox(height: 10),
            Container(
              width: 700,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: megaobraListBackgroundColors()[1],
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => {
                          if (mounted)
                            {
                              Future.microtask(() {
                                setState(() {
                                  selector = 0;
                                });
                              })
                            }
                        },
                        icon: const Icon(Icons.refresh),
                        color: megaobraButtonBackground(),
                      ),
                      const Spacer(),
                      Text(
                        AppLocalizations.of(context)!.moderators,
                        style: TextStyle(
                          color: selector == 0 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text(
                        AppLocalizations.of(context)!.activities,
                        style: TextStyle(
                          color: selector == 1 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text(
                        AppLocalizations.of(context)!.inCaseOfRain,
                        style: TextStyle(
                          color: selector == 2 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Opacity(
                        opacity: selector == 2 ? 0.3 : 1.0,
                        child: IconButton(
                          onPressed: () => {
                            if (mounted)
                              {
                                Future.microtask(() {
                                  setState(() {
                                    selector = getSelectorTab(selector, true);
                                  });
                                })
                              }
                          },
                          icon: const Icon(Icons.play_arrow),
                          color: megaobraButtonBackground(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (selector == 0)
                    SizedBox(
                      width: 600,
                      height: 260,
                      child: MegaObraUserSelector(
                        users: _loadedUsers,
                        onUserSelected: _handleEmployeesSelector,
                        searchBarLabel: AppLocalizations.of(context)!.searchForUsersToAddtoTheProject,
                      ),
                    )
                  else if (selector == 1)
                    SizedBox(
                      width: 600,
                      height: 260,
                      child: MegaObraActivitySelector(
                        activities: _loadedActivities,
                        onActivitySelected: _handleActivitiesSelector,
                        showSearchBar: true,
                        searchBarLabel: AppLocalizations.of(context)!.searchForActivitiesToAddtoTheProject,
                      ),
                    )
                  else if (selector == 2)
                    SizedBox(
                      width: 600,
                      height: 260,
                      child: SizedBox(
                        child: MegaObraActivitySelector(
                          activities: _loadedRainActivities,
                          onActivitySelected: _handleActivitiesRainSelector,
                          showSearchBar: true,
                          searchBarLabel: AppLocalizations.of(context)!.searchForActivitiesToAddtoTheProject,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 650,
              height: 60,
              child: MegaObraEmployeeDropdown(
                onUserSelected: _handleResponsibleSelector,
                label: formatStringByLength(
                  "${AppLocalizations.of(context)!.mainResponsible} (${AppLocalizations.of(context)!.original}: ${widget.responsible})",
                  60,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 310,
                  height: 60,
                  child: MegaObraDatePicker(
                    onDateSelected: _handleStartDateSelector,
                    label:
                        "${AppLocalizations.of(context)!.start} (${AppLocalizations.of(context)!.original}: ${formatDateTime(dateTime: widget.startDate)})",
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 310,
                  height: 60,
                  child: MegaObraDatePicker(
                    onDateSelected: _handleDeadlineSelector,
                    label:
                        "${AppLocalizations.of(context)!.deadline} (${AppLocalizations.of(context)!.original}: ${formatDateTime(dateTime: widget.deadlineDate)})",
                  ),
                ),
              ],
            ),
            MegaObraButton(
                width: 300,
                height: 40,
                text: AppLocalizations.of(context)!.updateProject,
                padding: const EdgeInsets.all(10.0),
                function: () => {
                      if (mounted)
                        {
                          tryToEditProject(
                            context,
                            generateProjectEdit(),
                          ),
                        }
                    }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
