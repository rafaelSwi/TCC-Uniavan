import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraThemeDropdown extends StatefulWidget {
  final Function(String) onThemeSelected;
  const MegaObraThemeDropdown({super.key, required this.onThemeSelected});

  @override
  State<MegaObraThemeDropdown> createState() => _MegaObraThemeDropdownState();
}

class _MegaObraThemeDropdownState extends State<MegaObraThemeDropdown> {
  final List<String> _themeItems = [
    'Laranja',
    'Metal',
    'Verde',
    'Oceano',
    'Canela',
  ];
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: megaobraButtonBackground(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTheme,
          dropdownColor: megaobraButtonBackground(),
          hint: Text(
            AppLocalizations.of(context)!.selectTheme,
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
          items: _themeItems.map((String theme) {
            return DropdownMenuItem<String>(
              value: theme,
              child: Text(
                theme,
                style: TextStyle(
                  color: megaobraColoredText(),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (mounted) {
              setState(
                () {
                  _selectedTheme = newValue;
                  widget.onThemeSelected(_selectedTheme!);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
