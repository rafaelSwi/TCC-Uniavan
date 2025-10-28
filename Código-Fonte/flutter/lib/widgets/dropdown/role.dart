import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraRoleDropdown extends StatefulWidget {
  final Function(String) onRoleSelected;
  const MegaObraRoleDropdown({super.key, required this.onRoleSelected});

  @override
  State<MegaObraRoleDropdown> createState() => _MegaObraRoleDropdownState();
}

class _MegaObraRoleDropdownState extends State<MegaObraRoleDropdown> {
  List<String> getRoleItens(BuildContext context) {
    return [
      AppLocalizations.of(context)!.professional,
      AppLocalizations.of(context)!.labourer,
      AppLocalizations.of(context)!.assistant,
      AppLocalizations.of(context)!.undefined,
    ];
  }

  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final roleItens = getRoleItens(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: megaobraButtonBackground(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          dropdownColor: megaobraButtonBackground(),
          hint: Text(
            AppLocalizations.of(context)!.selectRole,
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
          items: roleItens.map((String role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Row(
                children: [
                  Icon(
                    Icons.gavel,
                    color: megaobraColoredText(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    role,
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
                  _selectedRole = newValue;
                  widget.onRoleSelected(_selectedRole!);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
