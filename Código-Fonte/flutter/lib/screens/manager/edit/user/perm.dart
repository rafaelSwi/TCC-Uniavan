import 'package:MegaObra/utils/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/dropdown/permission.dart';
import 'package:MegaObra/crud/user.dart';

class EditUserPermissionScreen extends StatefulWidget {
  final User user;
  const EditUserPermissionScreen({super.key, required this.user});

  @override
  State<EditUserPermissionScreen> createState() => _EditUserPermissionScreenState();
}

class _EditUserPermissionScreenState extends State<EditUserPermissionScreen> {
  String _selectedPermission = "";

  void _onPermissionSelected(String permission) {
    if (mounted) {
      setState(() {
        _selectedPermission = permission;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  int getPermissionId(String permission, BuildContext context) {
    if (permission == AppLocalizations.of(context)!.admin) {
      return 1;
    } else if (permission == AppLocalizations.of(context)!.manager) {
      return 2;
    } else if (permission == AppLocalizations.of(context)!.worker) {
      return 3;
    } else if (permission == AppLocalizations.of(context)!.restricted) {
      return 4;
    } else {
      return 3;
    }
  }

  String permissionDesc(String permission) {
    if (permission == AppLocalizations.of(context)!.admin) {
      return AppLocalizations.of(context)!.permAdminDesc;
    } else if (permission == AppLocalizations.of(context)!.manager) {
      return AppLocalizations.of(context)!.permManagerDesc;
    } else if (permission == AppLocalizations.of(context)!.worker) {
      return AppLocalizations.of(context)!.permWorkerDesc;
    } else if (permission == AppLocalizations.of(context)!.restricted) {
      return AppLocalizations.of(context)!.permRestrictedDesc;
    } else {
      return AppLocalizations.of(context)!.selectPermissionToReadItsDescription;
    }
  }

  void updateUserRole(BuildContext context, String selectedRole, int user_id) {
    if (selectedRole == "") {
      return;
    }
    try {
      final Map<String, dynamic> updateData = {
        'permission_id': getPermissionId(selectedRole, context).toString(),
      };
      if (mounted) {
        updateUserProperty(context, user_id, updateData);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.updateUserPermission,
          text: AppLocalizations.of(context)!.requestToUpdatePerm,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to update a user permission: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingPerm,
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
            SizedBox(
              width: 350,
              height: 95,
              child: MegaObraTinyText(
                text: permissionDesc(_selectedPermission),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: MegaObraPermissionDropdown(
                onPermSelected: _onPermissionSelected,
                canSelectAdmin: true,
              ),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: _selectedPermission == "" ? 0.5 : 1.0,
              child: MegaObraButton(
                width: 300,
                height: 50,
                text: AppLocalizations.of(context)!.updateUserPermission,
                padding: const EdgeInsets.all(30.0),
                function: () => {
                  if (_selectedPermission != "" && mounted)
                    {
                      updateUserRole(context, _selectedPermission, widget.user.id),
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
