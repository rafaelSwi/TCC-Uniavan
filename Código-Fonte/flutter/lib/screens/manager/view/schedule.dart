import 'package:MegaObra/crud/schedule.dart';
import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/edit/schedule.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/utils/time_of_day.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/list/simple/employee.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class AdministratorScheduleViewer extends StatefulWidget {
  Schedule schedule;
  final int? userAmount;
  final bool? spectate;

  AdministratorScheduleViewer({
    super.key,
    required this.schedule,
    this.userAmount,
    this.spectate,
  });

  @override
  State<AdministratorScheduleViewer> createState() => _AdministratorScheduleViewerState();
}

class _AdministratorScheduleViewerState extends State<AdministratorScheduleViewer> {
  List<User> _loadedUsers = [];

  Future<void> collectUsers() async {
    if (!mounted) {
      return;
    }
    List<User> user_list = await getAllScheduleUsers(context, widget.schedule.id);
    if (mounted) {
      setState(() {
        _loadedUsers = user_list;
      });
    }
  }

  void refreshSchedule() async {
    Schedule? collectedSchedule = await getScheduleById(context, widget.schedule.id);
    if (collectedSchedule != null) {
      if (mounted) {
        setState(() {
          widget.schedule = collectedSchedule;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    collectUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void deprecateSchedule(bool isDeprecated, int schedule_id) async {
      if (schedule_id == 0) {
        return;
      }
      if (isDeprecated) {
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.invalidRequest,
            text: AppLocalizations.of(context)!.thisScheduleIsAlreadyMarkedAsDiscarded,
          );
        }
        return;
      }
      try {
        if (mounted) {
          bool? response = await markScheduleAsDeprecated(context, schedule_id);
          if (response == true) {
            showAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.schedule,
              text: AppLocalizations.of(context)!.requestToDeprecateScheduleSent,
              pop: true,
            );
          }
          return;
        } else if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorWhileDeprecateSchedule,
          );
          return;
        }
      } catch (e) {
        print("Error while trying to deprecate schedule: ${e}");
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorWhileDeprecateSchedule,
          );
        }
      }
    }

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

      return '${hours}h ${minutes}m';
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const MegaObraNavigatorPopButton(),
                  MegaObraRefreshButton(onPressed: refreshSchedule),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later,
                            color: megaobraIconColor(),
                            size: 80,
                          ),
                          const SizedBox(width: 20),
                          MegaObraDefaultText(
                            size: 50,
                            text: formatStringByLength(
                              widget.schedule.schedule_name,
                              25,
                            ),
                            fontWeight: FontWeight.w400,
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: MegaObraInformationContainer(
                                  maxWidth: 410,
                                  text: AppLocalizations.of(context)!.clockIn,
                                  sideText: widget.schedule.clock_in.toString(),
                                  fontSize: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: MegaObraInformationContainer(
                                  maxWidth: 410,
                                  text: AppLocalizations.of(context)!.workBreak,
                                  sideText: widget.schedule.break_in == null
                                      ? AppLocalizations.of(context)!.noBreak
                                      : widget.schedule.break_in.toString(),
                                  fontSize: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: MegaObraInformationContainer(
                                  maxWidth: 410,
                                  text: AppLocalizations.of(context)!.endOfBreak,
                                  sideText: widget.schedule.break_out == null
                                      ? AppLocalizations.of(context)!.noBreak
                                      : widget.schedule.break_out.toString(),
                                  fontSize: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: MegaObraInformationContainer(
                                  maxWidth: 410,
                                  text: AppLocalizations.of(context)!.clockOut,
                                  sideText: widget.schedule.clock_out.toString(),
                                  fontSize: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: MegaObraInformationContainer(
                                  maxWidth: 410,
                                  text: AppLocalizations.of(context)!.workingHours,
                                  sideText: timeDifference(
                                    clockIn: MegaObraTimeOfDay.convertToTimeOfDay(
                                      widget.schedule.clock_in,
                                    ),
                                    clockOut: MegaObraTimeOfDay.convertToTimeOfDay(
                                      widget.schedule.clock_out,
                                    ),
                                    breakStart: MegaObraTimeOfDay.convertToTimeOfDay(
                                      widget.schedule.break_in,
                                    ),
                                    breakEnd: MegaObraTimeOfDay.convertToTimeOfDay(
                                      widget.schedule.break_out,
                                    ),
                                  ),
                                  fontSize: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: MegaObraInformationContainer(
                                  maxWidth: 410,
                                  text: AppLocalizations.of(context)!.status,
                                  sideText: widget.schedule.deprecated
                                      ? AppLocalizations.of(context)!.deprecated
                                      : AppLocalizations.of(context)!.active,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            width: 330,
                            child: MegaObraSimpleEmployeeListWidget(
                              label: widget.userAmount == null
                                  ? AppLocalizations.of(context)!.users
                                  : "${AppLocalizations.of(context)!.users} (${widget.userAmount})",
                              ableToNavigate: widget.spectate == null ? true : !widget.spectate!,
                              employees: _loadedUsers,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Opacity(
                opacity: widget.schedule.deprecated || (widget.spectate ?? false) ? 0.5 : 1.0,
                child: Column(
                  children: [
                    MegaObraButton(
                      width: 270,
                      height: 35,
                      text: AppLocalizations.of(context)!.edit,
                      padding: const EdgeInsets.only(top: 55.0),
                      function: () => {
                        if (widget.schedule.deprecated || (widget.spectate ?? false))
                          {}
                        else
                          {
                            if (mounted)
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditScheduleScreen(
                                      schedule: widget.schedule,
                                      userAmount: widget.userAmount ?? 0,
                                    ),
                                  ),
                                ),
                              },
                          },
                      },
                    ),
                    MegaObraButton(
                      width: 270,
                      height: 50,
                      text: AppLocalizations.of(context)!.deprecateSchedule,
                      padding: const EdgeInsets.only(top: 15.0),
                      function: () => {
                        if (widget.schedule.deprecated || (widget.spectate ?? false))
                          {}
                        else if (mounted)
                          {
                            showQuestionAlertDialog(
                              context: context,
                              title: AppLocalizations.of(context)!.deprecate,
                              text: AppLocalizations.of(context)!.deprecateThisSchedule,
                              confirmText: AppLocalizations.of(context)!.yes,
                              cancelText: AppLocalizations.of(context)!.no,
                              onConfirm: () {
                                deprecateSchedule(
                                  widget.schedule.deprecated,
                                  widget.schedule.id,
                                );
                              },
                              onCancel: () {},
                            ),
                          }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
