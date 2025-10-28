import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/create/schedule.dart';
import 'package:MegaObra/screens/manager/view/schedule.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/time_of_day.dart';
import 'package:MegaObra/widgets/dropdown/permission.dart';
import 'package:MegaObra/widgets/dropdown/role.dart';
import 'package:MegaObra/widgets/dropdown/schedule.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';

class CreateUserScreen extends StatefulWidget {
  String setName;
  CreateUserScreen({super.key, this.setName = ""});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final double megaobraInfoMaxWidth = 220.0;
  late TextEditingController _nameController;
  late TextEditingController _cpfController;
  late TextEditingController _passwordController;
  String _selectedRole = 'Nenhum';
  String _selectedPermission = "";
  Schedule _selectedSchedule = const Schedule(
    id: 0,
    schedule_name: "Nenhuma",
    clock_in: MegaObraTimeOfDay(hour: 0, minute: 0, second: 0),
    clock_out: MegaObraTimeOfDay(hour: 0, minute: 0, second: 0),
    deprecated: false,
  );

  void _onPermissionSelected(String permission) {
    if (mounted) {
      setState(() {
        _selectedPermission = permission;
      });
    }
  }

  void _onScheduleSelected(Schedule schedule) {
    if (mounted) {
      setState(() {
        _selectedSchedule = schedule;
      });
    }
  }

  void _onRoleSelected(String role) {
    if (mounted) {
      setState(() {
        _selectedRole = role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: formattedName(widget.setName),
    );
    _cpfController = TextEditingController(
      text: null,
    );
    _passwordController = TextEditingController(
      text: null,
    );
    _nameController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool fieldsAreOk() {
    List<String> checks = [
      _nameController.text,
      _cpfController.text,
      _passwordController.text,
    ];
    if (_nameController.text.contains("  ")) {
      return false;
    }
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] == "") {
        return false;
      }
    }
    return true;
  }

  int makeItInt(String text) {
    try {
      return int.parse(text);
    } catch (e) {
      return 0;
    }
  }

  bool doesUserExist() {
    return true;
  }

  int getRoleId(BuildContext context, String role) {
    role = role.toLowerCase();
    if (role == AppLocalizations.of(context)!.professional.toLowerCase()) {
      return 1;
    } else if (role == AppLocalizations.of(context)!.labourer.toLowerCase()) {
      return 2;
    } else if (role == AppLocalizations.of(context)!.assistant.toLowerCase()) {
      return 3;
    } else {
      return 3;
    }
  }

  int getPermissionId(BuildContext context, String permission) {
    permission = permission.toLowerCase();
    if (permission == AppLocalizations.of(context)!.manager.toLowerCase()) {
      return 2;
    } else if (permission == AppLocalizations.of(context)!.worker.toLowerCase()) {
      return 3;
    } else if (permission == AppLocalizations.of(context)!.restricted.toLowerCase()) {
      return 4;
    } else {
      return 3;
    }
  }

  UserCreate generateUserCreate() {
    String name = formattedName(_nameController.text);
    return UserCreate(
      name: name,
      cpf: _cpfController.text.replaceAll(".", "").replaceAll("-", ""),
      password: _passwordController.text,
      permission_id: getPermissionId(context, _selectedPermission),
      role_id: getRoleId(context, _selectedRole),
      schedule_id: _selectedSchedule.id,
    );
  }

  String formattedName(String name) {
    try {
      return name.trim().split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    } catch (e) {
      return "";
    }
  }

  String belowMessage(String formatted_name) {
    String stock_return_message = AppLocalizations.of(context)!.nameWillHaveItsInitialsInCapitalLetters;
    try {
      if (formatted_name.isEmpty) {
        return stock_return_message;
      }
      String message = "${AppLocalizations.of(context)!.theNameWillBeRecognizedAs} \" ${formattedName(_nameController.text)} \".";
      if (message.length > 100) {
        return stock_return_message;
      }
      return message;
    } catch (e) {
      return stock_return_message;
    }
  }

  void tryToCreateNewUser(
    BuildContext context,
    UserCreate newUser,
  ) async {
    try {
      if (fieldsAreOk() == false) {
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.emptyFields,
            text: AppLocalizations.of(context)!.fillAllToCreateUser,
          );
        }
        return;
      }
      if (mounted) {
        await createNewUser(context, newUser);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.user,
          text: AppLocalizations.of(context)!.requestToCreateUserSent,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to create a user: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCreatingUser,
        );
      }
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
                  Icons.person_add,
                  color: megaobraIconColor(),
                  size: 70,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.createUser,
                  size: 40,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(height: 15),
            MegaObraTinyText(
              text: belowMessage(
                formattedName(_nameController.text),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 630,
              child: SizedBox(
                height: 60,
                child: MegaObraFieldName(
                  controller: _nameController,
                  label: AppLocalizations.of(context)!.name,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 315,
                  child: SizedBox(
                    height: 58,
                    child: MegaObraFieldCpf(
                      controller: _cpfController,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 315,
                  child: SizedBox(
                    height: 58,
                    child: MegaObraFieldPassword(
                      controller: _passwordController,
                      obscureText: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 315,
                  child: MegaObraPermissionDropdown(
                    onPermSelected: _onPermissionSelected,
                    canSelectAdmin: false,
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 315,
                  child: MegaObraRoleDropdown(onRoleSelected: _onRoleSelected),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 420,
                  child: MegaObraScheduleDropdown(
                    onScheduleSelected: _onScheduleSelected,
                    showRefreshButton: true,
                  ),
                ),
                const SizedBox(width: 20),
                Opacity(
                  opacity: _selectedSchedule.id != 0 ? 1.0 : 0.5,
                  child: MegaObraButton(
                    width: 300,
                    height: 30,
                    text: AppLocalizations.of(context)!.scheduleDetails,
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    function: () => {
                      if (_selectedSchedule.id != 0 && mounted)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdministratorScheduleViewer(
                                schedule: _selectedSchedule,
                                spectate: true,
                              ),
                              fullscreenDialog: true,
                            ),
                          ),
                        },
                    },
                  ),
                ),
                MegaObraButton(
                  width: 300,
                  height: 30,
                  text: AppLocalizations.of(context)!.createSchedule,
                  padding: const EdgeInsets.all(5.0),
                  function: () => {
                    if (mounted)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateScheduleScreen(),
                            fullscreenDialog: true,
                          ),
                        ),
                      },
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MegaObraButton(
              width: 300,
              height: 50,
              text: AppLocalizations.of(context)!.createUser,
              padding: const EdgeInsets.all(10.0),
              function: () {
                if (mounted) {
                  tryToCreateNewUser(
                    context,
                    generateUserCreate(),
                  );
                }
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
