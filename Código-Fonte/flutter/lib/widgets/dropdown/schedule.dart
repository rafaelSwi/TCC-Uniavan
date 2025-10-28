import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/utils/time_of_day.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/schedule.dart';

class MegaObraScheduleDropdown extends StatefulWidget {
  final Function(Schedule) onScheduleSelected;
  final bool showRefreshButton;
  const MegaObraScheduleDropdown({
    super.key,
    required this.onScheduleSelected,
    required this.showRefreshButton,
  });

  @override
  State<MegaObraScheduleDropdown> createState() => _MegaObraScheduleDropdownState();
}

class _MegaObraScheduleDropdownState extends State<MegaObraScheduleDropdown> {
  Future<List<Schedule>>? _scheduleItems;
  Schedule? _selectedSchedule;

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

    final clockInMinutes = timeToMinutes(clockIn);
    final clockOutMinutes = timeToMinutes(clockOut);

    final hours = actualWorkMinutes ~/ 60;
    final minutes = actualWorkMinutes % 60;

    if (clockOutMinutes < clockInMinutes) {
      return '0h 0m';
    }

    return '${hours}h ${minutes}m';
  }

  @override
  void initState() {
    super.initState();
    _scheduleItems = getAllSchedules(context);
  }

  Future<void> _showSearchDialog() async {
    String searchQuery = '';
    final schedules = await _scheduleItems;

    if (schedules != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: megaobraButtonBackground(),
            title: Row(
              children: [
                Icon(
                  Icons.search,
                  color: megaobraColoredText(),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.search,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: megaobraColoredText(),
                  ),
                ),
              ],
            ),
            content: TextField(
              onChanged: (value) {
                searchQuery = value;
              },
              style: TextStyle(color: megaobraColoredText()),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: megaobraColoredText()),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: megaobraColoredText()),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: megaobraColoredText()),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.watch_later,
                  color: megaobraNeutralText(),
                ),
                filled: true,
                fillColor: megaobraBackgroundColors()[1],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: megaobraAlertText(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: megaobraNeutralText()),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final filteredSchedules = schedules
                      .where((schedule) => schedule.schedule_name.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();
                  if (mounted) {
                    setState(() {
                      _scheduleItems = Future.value(filteredSchedules);
                    });
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: megaobraSwitchBackground(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.filter,
                  style: TextStyle(color: megaobraNeutralText()),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: megaobraButtonBackground(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FutureBuilder<List<Schedule>>(
        future: _scheduleItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              AppLocalizations.of(context)!.errorLoadingSchedules,
              style: TextStyle(color: megaobraAlertText()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Schedule> schedules = snapshot.data!;

            return Row(
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<Schedule>(
                    value: _selectedSchedule,
                    dropdownColor: megaobraButtonBackground(),
                    hint: Text(
                      AppLocalizations.of(context)!.selectSchedule,
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
                    items: schedules.map((Schedule schedule) {
                      return DropdownMenuItem<Schedule>(
                        value: schedule,
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later,
                              color: megaobraColoredText(),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: widget.showRefreshButton ? 150 : 190,
                              child: Text(
                                formatStringByLength(schedule.schedule_name, 25),
                                style: TextStyle(
                                  color: megaobraColoredText(),
                                ),
                              ),
                            ),
                            Text(
                              timeDifference(
                                clockIn: MegaObraTimeOfDay.convertToTimeOfDay(
                                  schedule.clock_in,
                                ),
                                clockOut: MegaObraTimeOfDay.convertToTimeOfDay(
                                  schedule.clock_out,
                                ),
                                breakStart: MegaObraTimeOfDay.convertToTimeOfDay(
                                  schedule.break_in,
                                ),
                                breakEnd: MegaObraTimeOfDay.convertToTimeOfDay(
                                  schedule.break_out,
                                ),
                              ),
                              style: TextStyle(
                                color: megaobraColoredText(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Schedule? newValue) {
                      if (mounted) {
                        setState(() {
                          _selectedSchedule = newValue;
                          widget.onScheduleSelected(_selectedSchedule!);
                        });
                      }
                    },
                  ),
                ),
                if (widget.showRefreshButton)
                  IconButton(
                    onPressed: () async {
                      if (!mounted) {
                        return;
                      }
                      final downloadedSchedules = await getAllSchedules(context);
                      if (mounted) {
                        setState(() {
                          _scheduleItems = Future.value(downloadedSchedules);

                          if (!downloadedSchedules.contains(_selectedSchedule)) {
                            _selectedSchedule = null;
                          }
                        });
                      }
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: megaobraColoredText(),
                      size: 20,
                    ),
                  ),
                IconButton(
                  onPressed: _showSearchDialog,
                  icon: Icon(
                    Icons.search,
                    color: megaobraColoredText(),
                    size: 20,
                  ),
                ),
              ],
            );
          } else {
            return Text(
              AppLocalizations.of(context)!.noScheduleAvailable,
              style: TextStyle(
                color: megaobraAlertText(),
              ),
            );
          }
        },
      ),
    );
  }
}
