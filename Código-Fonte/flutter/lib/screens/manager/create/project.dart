import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/screens/manager/edit/selection/activities.dart';
import 'package:MegaObra/screens/manager/edit/selection/users.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/widgets/dropdown/employee.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/user.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
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
  List<int> _multipleActivity = [];
  List<int> _multipleEmployee = [];
  List<int> _multipleRain = [];
  late TextEditingController _titleController;

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
          _multipleEmployee = users.map((user) => user.id).toList();
        });
      });
    }
  }

  void _handleActivitiesSelector(List<Activity> activities) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _multipleActivity = activities.map((act) => act.id).toList();
        });
      });
    }
  }

  void _handleActivitiesRainSelector(List<Activity> activities) {
    if (mounted) {
      Future.microtask(() {
        setState(() {
          _multipleRain = activities.map((rain) => rain.id).toList();
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
    if (mounted) {
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
  }

  List<int> convertActivitiesIntoIntList(List<Activity> activity_list) {
    List<int> return_list = [];
    for (int i = 0; i < activity_list.length; i++) {
      return_list.add(activity_list[i].id);
    }
    return return_list;
  }

  Future<List<Activity>> collectActivities() async {
    return await getAssociatedActivities(context, true);
  }

  void tryToCreateNewProject(
    BuildContext context,
    ProjectCreate newProject,
  ) async {
    try {
      await createNewProject(context, newProject);
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.project,
        text: AppLocalizations.of(context)!.requestToCreateProjectSent,
        pop: true,
      );
    } catch (e) {
      print("Error while trying to create a project: $e");
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.error,
        text: AppLocalizations.of(context)!.errorWhileCreatingProject,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: null,
    );
    loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ProjectCreate generateProjectCreate() {
    return ProjectCreate(
      start_date: _startDateSelector ?? DateTime(0),
      deadline_date: _deadlineSelector ?? DateTime(0),
      active: true,
      responsible_id: _selectedResponsible.id,
      rain: _multipleRain,
      employee: _multipleEmployee,
      activity: _multipleActivity,
      title: _titleController.text,
    );
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
                  Icons.list,
                  color: megaobraIconColor(),
                  size: 70,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.createProject,
                  size: 40,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 470,
              child: MegaObraFieldName(
                controller: _titleController,
                maxLength: 128,
                allowNumbers: false,
                label: AppLocalizations.of(context)!.projectTitle,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MegaObraButton(
                  width: 300,
                  height: 40,
                  text: AppLocalizations.of(context)!.selectModerators,
                  padding: const EdgeInsets.all(15.0),
                  function: () => {
                    if (mounted)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSelectionPage(
                              selectedUserIds: _multipleEmployee,
                              onApply: (values) => {
                                if (mounted)
                                  {
                                    setState(() {
                                      _multipleEmployee = values;
                                    }),
                                  }
                              },
                            ),
                          ),
                        ),
                      },
                  },
                ),
                const SizedBox(height: 5),
                MegaObraDefaultText(
                  text: "${_multipleEmployee.length} ${AppLocalizations.of(context)!.selectedPlural}.",
                  size: 17,
                ),
                const SizedBox(height: 17),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 650,
              height: 60,
              child: MegaObraEmployeeDropdown(
                onUserSelected: _handleResponsibleSelector,
                label: AppLocalizations.of(context)!.mainResponsible,
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
                    label: AppLocalizations.of(context)!.startDate,
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
                    label: AppLocalizations.of(context)!.deadlineDate,
                  ),
                ),
              ],
            ),
            MegaObraButton(
                width: 300,
                height: 40,
                text: AppLocalizations.of(context)!.createProject,
                padding: const EdgeInsets.all(10.0),
                function: () => {
                      tryToCreateNewProject(
                        context,
                        generateProjectCreate(),
                      )
                    }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
