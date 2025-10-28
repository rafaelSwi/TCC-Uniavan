import 'package:MegaObra/utils/customization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MegaObraDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final String label;
  const MegaObraDatePicker({
    super.key,
    required this.onDateSelected,
    this.label = "",
  });

  @override
  State<MegaObraDatePicker> createState() => _MegaObraDatePickerState();
}

class _MegaObraDatePickerState extends State<MegaObraDatePicker> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: megaobraDatePickerPrimary(),
              onPrimary: megaobraDatePickerText(),
              onSurface: megaobraDatePickerText(),
            ),
            dialogBackgroundColor: megaobraButtonBackground(),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      if (mounted) {
        setState(() {
          _selectedDate = picked;
        });
        widget.onDateSelected(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: megaobraButtonBackground(),
          border: Border.all(
            color: megaobraListDivider(),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null ? widget.label : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              style: TextStyle(
                color: megaobraColoredText(),
                fontSize: 17,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: megaobraColoredText(),
            ),
          ],
        ),
      ),
    );
  }
}
