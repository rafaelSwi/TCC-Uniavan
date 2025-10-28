import 'package:MegaObra/crud/schedule.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/time_of_day.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/utils/customization.dart';

class CreateScheduleScreen extends StatefulWidget {
  CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  bool hasBreak = true;
  late TextEditingController _nameController;
  TimeOfDay? clock_in;
  TimeOfDay? break_in;
  TimeOfDay? break_out;
  TimeOfDay? clock_out;

  String timeDifference({
    required TimeOfDay clockIn,
    required TimeOfDay clockOut,
    TimeOfDay? breakStart,
    TimeOfDay? breakEnd,
  }) {
    int timeToMinutes(TimeOfDay time) {
      return time.hour * 60 + time.minute;
    }

    final totalWorkMinutes = timeToMinutes(clockOut) - timeToMinutes(clockIn);

    int breakMinutes = 0;

    if (breakStart != null && breakEnd != null) {
      breakMinutes = timeToMinutes(breakEnd) - timeToMinutes(breakStart);
    }

    final actualWorkMinutes = totalWorkMinutes - breakMinutes;

    final hours = actualWorkMinutes ~/ 60;
    final minutes = actualWorkMinutes % 60;

    final clockInMinutes = timeToMinutes(clockIn);
    final clockOutMinutes = timeToMinutes(clockOut);

    if (clockOutMinutes < clockInMinutes) {
      return '0h 0m';
    }

    return '${hours}h ${minutes}m';
  }

  Future<void> _selectTime(BuildContext context, String label, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      confirmText: AppLocalizations.of(context)!.apply,
      cancelText: AppLocalizations.of(context)!.cancel,
      helpText: AppLocalizations.of(context)!.timeSelection,
      hourLabelText: AppLocalizations.of(context)!.hour,
      minuteLabelText: AppLocalizations.of(context)!.minute,
      errorInvalidText: AppLocalizations.of(context)!.invalid,
      orientation: Orientation.portrait,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: TimePickerThemeData(),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (mounted) {
        setState(() {
          onTimeSelected(picked);
        });
      }
    }
  }

  ScheduleCreate generateScheduleCreate() {
    if (!hasBreak) {
      return ScheduleCreate(
        schedule_name: _nameController.text,
        clock_in: MegaObraTimeOfDay(
          hour: clock_in?.hour ?? 0,
          minute: clock_in?.minute ?? 0,
          second: 0,
        ),
        clock_out: MegaObraTimeOfDay(
          hour: clock_out?.hour ?? 0,
          minute: clock_out?.minute ?? 0,
          second: 0,
        ),
        break_in: null,
        break_out: null,
      );
    } else {
      return ScheduleCreate(
        schedule_name: _nameController.text,
        clock_in: MegaObraTimeOfDay(
          hour: clock_in?.hour ?? 0,
          minute: clock_in?.minute ?? 0,
          second: 0,
        ),
        clock_out: MegaObraTimeOfDay(
          hour: clock_out?.hour ?? 0,
          minute: clock_out?.minute ?? 0,
          second: 0,
        ),
        break_in: MegaObraTimeOfDay(
          hour: break_in?.hour ?? 0,
          minute: break_in?.minute ?? 0,
          second: 0,
        ),
        break_out: MegaObraTimeOfDay(
          hour: break_out?.hour ?? 0,
          minute: break_out?.minute ?? 0,
          second: 0,
        ),
      );
    }
  }

  void tryToCreateNewSchedule(
    BuildContext context,
    ScheduleCreate newSchedule,
  ) async {
    try {
      if (mounted) {
        await createNewSchedule(context, newSchedule);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.schedule,
          text: AppLocalizations.of(context)!.requestToCreateScheduleSent,
          onConfirm: () {},
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to create a schedule: $e");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCreatingSchedule,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool areFieldsOk() {
    bool ok = true;
    if (["", null].contains(_nameController.text)) {
      ok = false;
    }
    if (hasBreak) {
      if ([clock_in, clock_out, break_in, break_out].contains(null)) {
        ok = false;
      }
    } else {
      if ([clock_in, clock_out].contains(null)) {
        ok = false;
      }
    }
    return ok;
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
                  Icons.watch_later,
                  color: megaobraIconColor(),
                  size: 90,
                ),
                const SizedBox(width: 40),
                MegaObraDefaultText(
                  text: ![clock_in, clock_out].contains(null)
                      ? timeDifference(
                          clockIn: clock_in!,
                          clockOut: clock_out!,
                          breakStart: break_in,
                          breakEnd: break_out,
                        )
                      : "0h 0m",
                  fontWeight: FontWeight.w400,
                  size: 90,
                ),
              ],
            ),
            SizedBox(
              width: 470,
              child: MegaObraFieldName(
                controller: _nameController,
                maxLength: 64,
                allowNumbers: false,
                label: AppLocalizations.of(context)!.scheduleTitle,
              ),
            ),

            _buildTimePickerRow(
              AppLocalizations.of(context)!.clockIn,
              clock_in,
              (value) => clock_in = value,
              false,
            ),
            _buildTimePickerRow(
              AppLocalizations.of(context)!.startOfBreak,
              break_in,
              (value) => break_in = value,
              !hasBreak,
            ),
            _buildTimePickerRow(
              AppLocalizations.of(context)!.endOfBreak,
              break_out,
              (value) => break_out = value,
              !hasBreak,
            ),
            _buildTimePickerRow(
              AppLocalizations.of(context)!.clockOut,
              clock_out,
              (value) => clock_out = value,
              false,
            ),
            Column(
              children: [
                const SizedBox(height: 40),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.workBreak,
                  size: 20,
                ),
                MegaObraSwitch(
                  value: hasBreak,
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() {
                          hasBreak = value;
                        }),
                      }
                  },
                ),
              ],
            ),
            const Spacer(),
            // Save Button
            MegaObraButton(
              width: 300,
              height: 35,
              text: AppLocalizations.of(context)!.createSchedule,
              padding: const EdgeInsets.all(10.0),
              function: () => {
                if (!areFieldsOk())
                  {
                    if (mounted)
                      {
                        showAlertDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.unresolved,
                          text: AppLocalizations.of(context)!.someInformationNeedsToBeFilled,
                        ),
                      }
                  }
                else
                  {
                    if (mounted)
                      {
                        showQuestionAlertDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.create,
                          text: AppLocalizations.of(context)!.createThisSchedule,
                          confirmText: AppLocalizations.of(context)!.yes,
                          cancelText: AppLocalizations.of(context)!.no,
                          onCancel: () {},
                          onConfirm: () {
                            if (mounted) {
                              tryToCreateNewSchedule(
                                context,
                                generateScheduleCreate(),
                              );
                            }
                          },
                        ),
                      }
                  }
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerRow(
    String label,
    TimeOfDay? time,
    Function(TimeOfDay) onTimeSelected,
    bool disabled,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MegaObraInformationContainer(
              text: label,
              maxWidth: 300,
            ),
            TextButton(
              onPressed: () => disabled
                  ? {}
                  : mounted
                      ? _selectTime(context, label, onTimeSelected)
                      : {},
              child: Container(
                decoration:
                    BoxDecoration(color: megaobraButtonBackground(), borderRadius: const BorderRadius.all(Radius.circular(10))),
                width: 150,
                height: 30,
                child: Center(
                  child: Text(
                    disabled
                        ? AppLocalizations.of(context)!.noBreak
                        : time != null
                            ? mounted
                                ? time.format(context)
                                : "- ? -"
                            : AppLocalizations.of(context)!.select,
                    style: TextStyle(
                      fontSize: 16,
                      color: megaobraColoredText(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
