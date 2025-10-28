import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/info/container.dart';

class EditActivityScreen extends StatefulWidget {
  final Activity activity;
  const EditActivityScreen({super.key, required this.activity});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  final double megaobraInfoMaxWidth = 220.0;
  late TextEditingController _descController;
  late TextEditingController _proAmountController;
  late TextEditingController _proTimeController;
  late TextEditingController _labAmountController;
  late TextEditingController _labTimeController;
  DateTime? _startDateSelector;
  DateTime? _deadlineSelector;

  @override
  void dispose() {
    _descController.dispose();
    _proAmountController.dispose();
    _proTimeController.dispose();
    _labAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: widget.activity.description,
    );
    _proAmountController = TextEditingController(
      text: widget.activity.professional_amount.toString(),
    );
    _proTimeController = TextEditingController(
      text: widget.activity.professional_minutes.toString(),
    );
    _labAmountController = TextEditingController(
      text: widget.activity.laborer_amount.toString(),
    );
    _labTimeController = TextEditingController(
      text: widget.activity.laborer_minutes.toString(),
    );
  }

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

  void changeActivityProperties(BuildContext context) async {
    try {
      final Map<String, dynamic> updateData = {
        'description': _descController.text == "" ? widget.activity.description : _descController.text,
        'professional_amount':
            _proAmountController.text == "" ? widget.activity.professional_amount.toString() : _proAmountController.text,
        'laborer_amount': _labAmountController.text == "" ? widget.activity.laborer_amount.toString() : _labAmountController.text,
        'professional_minutes':
            _proTimeController.text == "" ? widget.activity.professional_minutes.toString() : _proTimeController.text,
        'laborer_minutes': _labTimeController.text == "" ? widget.activity.laborer_minutes.toString() : _labTimeController.text,
        'start_date':
            _startDateSelector == null ? widget.activity.start_date.toIso8601String() : _startDateSelector?.toIso8601String(),
        'deadline_date':
            _deadlineSelector == null ? widget.activity.deadline_date.toIso8601String() : _deadlineSelector?.toIso8601String(),
      };
      if (mounted) {
        final response = await updateActivityProperty(
          context,
          widget.activity.id,
          updateData,
        );
        if (response != null) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.activity,
            text: AppLocalizations.of(context)!.requestToUpdateActivity,
            pop: true,
          );
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.activity,
          text: AppLocalizations.of(context)!.errorWhileUpdatingActivity,
        );
      }
    } catch (e) {
      print("Error while trying to update a activity property: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingActivity,
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
                  Icons.edit_document,
                  color: megaobraIconColor(),
                  size: 70,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: formatStringByLength(widget.activity.description, 30),
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.professionals,
                          maxWidth: megaobraInfoMaxWidth,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.amount}: ${widget.activity.professional_amount}",
                          maxWidth: megaobraInfoMaxWidth,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.time}: ${widget.activity.professional_minutes}m",
                          maxWidth: megaobraInfoMaxWidth,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 30.0,
                      right: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.labourers,
                          maxWidth: megaobraInfoMaxWidth,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.amount}: ${widget.activity.laborer_amount}",
                          maxWidth: megaobraInfoMaxWidth,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.time}: ${widget.activity.laborer_minutes}m",
                          maxWidth: megaobraInfoMaxWidth,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 340,
                  height: 60,
                  child: MegaObraDatePicker(
                    onDateSelected: _handleStartDateSelector,
                    label:
                        "${AppLocalizations.of(context)!.start} (${AppLocalizations.of(context)!.original}: ${formatDateTime(dateTime: widget.activity.start_date)})",
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 340,
                  height: 60,
                  child: MegaObraDatePicker(
                    onDateSelected: _handleDeadlineSelector,
                    label:
                        "${AppLocalizations.of(context)!.deadline} (${AppLocalizations.of(context)!.original}: ${formatDateTime(dateTime: widget.activity.deadline_date)})",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 630,
              child: MegaObraFieldName(
                controller: _descController,
                label: AppLocalizations.of(context)!.description,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 315,
                  child: MegaObraFieldNumerical(
                    controller: _proAmountController,
                    label: AppLocalizations.of(context)!.professionalAmount,
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 315,
                  child: MegaObraFieldNumerical(
                    controller: _labAmountController,
                    label: AppLocalizations.of(context)!.labourerAmount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 315,
                  child: MegaObraFieldNumerical(
                    controller: _proTimeController,
                    label: AppLocalizations.of(context)!.minutesForEachProfessional,
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 315,
                  child: MegaObraFieldNumerical(
                    controller: _labTimeController,
                    label: AppLocalizations.of(context)!.minutesForEachLabourer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MegaObraButton(
              width: 300,
              height: 50,
              text: AppLocalizations.of(context)!.updateActivity,
              padding: const EdgeInsets.all(30.0),
              function: () => {
                if (mounted)
                  {
                    changeActivityProperties(context),
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
