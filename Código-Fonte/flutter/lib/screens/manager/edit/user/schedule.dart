import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/time_of_day.dart';
import 'package:MegaObra/widgets/dropdown/schedule.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/screens/manager/view/schedule.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/user.dart';

class EditUserScheduleScreen extends StatefulWidget {
  final User user;
  const EditUserScheduleScreen({super.key, required this.user});

  @override
  State<EditUserScheduleScreen> createState() => _EditUserScheduleScreenState();
}

class _EditUserScheduleScreenState extends State<EditUserScheduleScreen> {
  Schedule _selectedSchedule = const Schedule(
    id: 0,
    schedule_name: "Nenhuma",
    clock_in: MegaObraTimeOfDay(hour: 0, minute: 0, second: 0),
    clock_out: MegaObraTimeOfDay(hour: 0, minute: 0, second: 0),
    deprecated: false,
  );

  void _onScheduleSelected(Schedule schedule) {
    if (mounted) {
      setState(() {
        _selectedSchedule = schedule;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void updateUserSchedule(
    BuildContext context,
    Schedule selectedSchedule,
    int user_id,
  ) {
    try {
      if (selectedSchedule.id == 0) {
        return;
      }
      final Map<String, dynamic> updateData = {
        'schedule_id': selectedSchedule.id.toString(),
      };
      if (mounted) {
        updateUserProperty(context, user_id, updateData);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.scheduleUpdate,
          text: AppLocalizations.of(context)!.requestToCreateScheduleSent,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to update a user schedule: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingSchedule,
        );
      }
    }
  }

  void viewScheduleNavigator() async {
    try {
      if (_selectedSchedule.id == 0) {
        return;
      }
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministratorScheduleViewer(
              schedule: _selectedSchedule,
              spectate: true,
            ),
          ),
        );
      }
    } catch (e) {
      print("e: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorOpeningSchedule,
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
              text: AppLocalizations.of(context)!.scheduleChangesTakesTime,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 420,
              child: MegaObraScheduleDropdown(
                onScheduleSelected: _onScheduleSelected,
                showRefreshButton: false,
              ),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: _selectedSchedule.id == 0 ? 0.5 : 1.0,
              child: MegaObraButton(
                width: 400,
                height: 50,
                text: AppLocalizations.of(context)!.scheduleDetails,
                padding: const EdgeInsets.all(20.0),
                function: () => {
                  viewScheduleNavigator(),
                },
              ),
            ),
            Opacity(
              opacity: _selectedSchedule.id == 0 ? 0.5 : 1.0,
              child: MegaObraButton(
                width: 400,
                height: 50,
                text: AppLocalizations.of(context)!.updateUserSchedule,
                padding: const EdgeInsets.all(20.0),
                function: () => {
                  if (mounted)
                    {
                      updateUserSchedule(context, _selectedSchedule, widget.user.id),
                    },
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
