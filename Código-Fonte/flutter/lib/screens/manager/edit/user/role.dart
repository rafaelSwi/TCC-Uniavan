import 'package:MegaObra/utils/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/dropdown/role.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/user.dart';

class EditUserRoleScreen extends StatefulWidget {
  final User user;
  const EditUserRoleScreen({super.key, required this.user});

  @override
  State<EditUserRoleScreen> createState() => _EditUserRoleScreenState();
}

class _EditUserRoleScreenState extends State<EditUserRoleScreen> {
  String _selectedRole = 'Nenhum';

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
  }

  int getRoleId(String role, BuildContext context) {
    if (role == AppLocalizations.of(context)!.professional) {
      return 1;
    } else if (role == AppLocalizations.of(context)!.labourer) {
      return 2;
    } else if (role == AppLocalizations.of(context)!.assistant) {
      return 3;
    } else {
      return 0;
    }
  }

  void updateUserRole(BuildContext context, String selectedRole, int user_id) {
    try {
      final Map<String, dynamic> updateData = {
        'role_id': getRoleId(selectedRole, context).toString(),
      };
      if (mounted) {
        updateUserProperty(context, user_id, updateData);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.roleUpdate,
          text: AppLocalizations.of(context)!.requestToUpdateRole,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to update a user role: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingRole,
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
                  Icons.person,
                  color: megaobraIconColor(),
                  size: 80,
                ),
                const SizedBox(width: 25),
                MegaObraDefaultText(
                  text: widget.user.name,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 40),
            MegaObraTinyText(
              text: AppLocalizations.of(context)!.roleChangesTakesTime,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: MegaObraRoleDropdown(onRoleSelected: _onRoleSelected),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: _selectedRole == "Nenhum" ? 0.5 : 1.0,
              child: MegaObraButton(
                width: 300,
                height: 50,
                text: AppLocalizations.of(context)!.updateUserRole,
                padding: const EdgeInsets.all(30.0),
                function: () => {
                  if (_selectedRole != "Nenhum" && mounted)
                    {
                      updateUserRole(context, _selectedRole, widget.user.id),
                    }
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
