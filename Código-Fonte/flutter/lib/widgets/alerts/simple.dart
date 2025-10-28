import 'package:MegaObra/utils/customization.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraAlertDialog extends StatelessWidget {
  final String title;
  final String text;
  final String confirmText;
  final bool pop;
  final VoidCallback? onConfirm;

  const MegaObraAlertDialog({
    Key? key,
    required this.title,
    required this.text,
    this.confirmText = "OK",
    this.pop = false,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: megaobraButtonBackground(),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: megaobraColoredText(),
        ),
      ),
      content: Text(
        text,
        style: TextStyle(
          color: megaobraColoredText(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (pop) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          child: Text(
            confirmText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: megaobraColoredText(),
            ),
          ),
        ),
      ],
    );
  }
}

class MegaObraQuestionAlertDialog extends StatelessWidget {
  final String title;
  final String text;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  MegaObraQuestionAlertDialog({
    Key? key,
    required this.title,
    required this.text,
    required this.onConfirm,
    this.confirmText = "OK",
    this.cancelText = "Canc.",
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: megaobraButtonBackground(),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: megaobraColoredText(),
        ),
      ),
      content: Text(
        text,
        style: TextStyle(
          color: megaobraColoredText(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          child: Text(
            cancelText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: megaobraColoredText(),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(true);
          },
          child: Text(
            confirmText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: megaobraColoredText(),
            ),
          ),
        ),
      ],
    );
  }
}

class MegaObraDatePickerAlertDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final String selectDateText;
  final Function(DateTime?) onConfirm;
  final VoidCallback? onCancel;

  MegaObraDatePickerAlertDialog({
    Key? key,
    required this.title,
    required this.onConfirm,
    required this.selectDateText,
    this.confirmText = "OK",
    this.cancelText = "Canc.",
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;

    return AlertDialog(
      backgroundColor: megaobraButtonBackground(),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: megaobraColoredText(),
        ),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() {
                    selectedDate = pickedDate;
                  });
                },
                child: Text(
                  selectedDate != null
                      ? "${AppLocalizations.of(context)!.selectedDate}: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : selectDateText,
                  style: TextStyle(
                    color: megaobraColoredText(),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            cancelText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: megaobraColoredText(),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm(selectedDate);
            Navigator.of(context).pop();
          },
          child: Text(
            confirmText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: megaobraColoredText(),
            ),
          ),
        ),
      ],
    );
  }
}
