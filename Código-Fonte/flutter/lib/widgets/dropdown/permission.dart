import 'package:MegaObra/utils/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraPermissionDropdown extends StatefulWidget {
  final Function(String) onPermSelected;
  final bool canSelectAdmin;
  const MegaObraPermissionDropdown({
    super.key,
    required this.onPermSelected,
    required this.canSelectAdmin,
  });

  @override
  State<MegaObraPermissionDropdown> createState() => _MegaObraPermissionDropdownState();
}

class _MegaObraPermissionDropdownState extends State<MegaObraPermissionDropdown> {
  List<String> getPermItens(BuildContext context) {
    return [
      AppLocalizations.of(context)!.admin,
      AppLocalizations.of(context)!.manager,
      AppLocalizations.of(context)!.worker,
      AppLocalizations.of(context)!.restricted,
    ];
  }

  String? _selectedPerm;

  @override
  Widget build(BuildContext context) {
    final permItems = getPermItens(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: megaobraButtonBackground(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPerm,
          dropdownColor: megaobraButtonBackground(),
          hint: Text(
            AppLocalizations.of(context)!.selectPermission,
            style: TextStyle(
              color: megaobraColoredText(),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: megaobraColoredText(),
            size: 50,
          ),
          style: TextStyle(
            color: megaobraColoredText(),
            fontSize: 18,
          ),
          items: permItems.map((String permission) {
            return DropdownMenuItem<String>(
              value: permission,
              child: Row(
                children: [
                  Icon(
                    Icons.memory,
                    color: megaobraColoredText(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    permission,
                    style: TextStyle(
                      color: megaobraColoredText(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (mounted) {
              setState(
                () {
                  if (!widget.canSelectAdmin && newValue == AppLocalizations.of(context)!.admin && mounted) {
                    return showAlertDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.warning,
                      text: AppLocalizations.of(context)!.notPossibleToCreateAdminUser,
                    );
                  }
                  _selectedPerm = newValue;
                  widget.onPermSelected(_selectedPerm!);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
