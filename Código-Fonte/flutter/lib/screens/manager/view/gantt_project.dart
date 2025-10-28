import 'dart:ui';
import 'package:MegaObra/models/activity.dart';
import 'package:collection/collection.dart';
import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad};
}

class GanttChartFromProjects extends StatefulWidget {
  final List<ProjectSuperSimplified> projects;

  const GanttChartFromProjects({
    super.key,
    this.projects = const [],
  });

  @override
  State<GanttChartFromProjects> createState() => _GanttChartFromProjectsState();
}

class _GanttChartFromProjectsState extends State<GanttChartFromProjects> {
  List<ProjectSuperSimplified> loadedProjects = [];
  final scrollController = ScrollController();

  double dayWidth = 30;
  bool showDaysRow = true;
  bool showStickyArea = true;
  bool customStickyArea = false;
  bool customWeekHeader = false;
  bool customDayHeader = false;

  void initState() {
    super.initState();
    loadProjects();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadProjects() async {
    if (!mounted) {
      return;
    }
    if (widget.projects.isEmpty) {
      var result = await getProjectsCloseToDeadline(context, null);
      if (mounted) {
        setState(() {
          loadedProjects = result;
        });
      }
    } else {
      loadedProjects = widget.projects;
    }
  }

  List<GanttAbsoluteEvent> convertProjectsToGanttEvents(
    List<ProjectSuperSimplified> projects,
  ) {
    List<GanttAbsoluteEvent> ganttEvents = [];
    for (int i = 0; i < projects.length; i++) {
      var ganttEvent = GanttAbsoluteEvent(
        displayName: formatStringByLength(projects[i].title, 21),
        startDate: projects[i].start_date,
        endDate: projects[i].deadline_date,
      );
      ganttEvents.add(ganttEvent);
      if (ganttEvents.length > 9) {
        return ganttEvents;
      }
    }
    return ganttEvents;
  }

  void onZoomIn() {
    if (mounted) {
      setState(() {
        dayWidth += 5;
      });
    }
  }

  void onZoomOut() {
    if (dayWidth <= 10) return;
    if (mounted) {
      setState(() {
        dayWidth -= 5;
      });
    }
  }

  double _containerHeight(int listSize) {
    double result = (300 - (20 * listSize)).toDouble();
    if (result < 50) {
      result = 50;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          if (scrollController.offset < scrollController.position.maxScrollExtent) {
            scrollController.jumpTo(scrollController.offset + 20);
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          if (scrollController.offset > scrollController.position.minScrollExtent) {
            scrollController.jumpTo(scrollController.offset - 20);
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.keyD)) {
          if (scrollController.offset < scrollController.position.maxScrollExtent) {
            scrollController.jumpTo(scrollController.offset + 90);
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.keyA)) {
          if (scrollController.offset > scrollController.position.minScrollExtent) {
            scrollController.jumpTo(scrollController.offset - 90);
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.equal)) {
          onZoomIn();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.minus)) {
          onZoomOut();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: megaobraBackgroundColors(),
              begin: megaobraBackgroundGradientdStart(),
              end: megaobraBackgroundGradientdEnd(),
            ),
          ),
          child: Column(
            children: [
              const MegaObraNavigatorPopButton(),
              const Spacer(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    MegaObraDefaultText(
                      text: AppLocalizations.of(context)!.navigateHorizontallyControlsTip,
                      size: 24,
                    ),
                    MegaObraTinyText(
                      text: AppLocalizations.of(context)!.navigateHorizontallyTouchTip,
                    ),
                    Divider(
                      color: megaobraListDivider(),
                    ),
                    GanttChartView(
                      scrollPhysics: const BouncingScrollPhysics(),
                      stickyAreaWeekBuilder: (context) {
                        return MegaObraDefaultText(
                          text: AppLocalizations.of(context)!.navigation,
                          size: 16,
                        );
                      },
                      stickyAreaDayBuilder: (context) {
                        return AnimatedBuilder(
                          animation: scrollController,
                          builder: (context, _) {
                            final pos = scrollController.positions.firstOrNull;
                            final currentOffset = pos?.pixels ?? 0;
                            final maxOffset = pos?.maxScrollExtent ?? double.infinity;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              // bottom: 0,
                              children: [
                                IconButton(
                                  onPressed: currentOffset > 0
                                      ? () {
                                          scrollController.jumpTo(scrollController.offset - 50);
                                        }
                                      : null,
                                  color: megaobraIconColor(),
                                  icon: const Icon(
                                    Icons.arrow_left,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: currentOffset < maxOffset
                                      ? () {
                                          scrollController.jumpTo(scrollController.offset + 50);
                                        }
                                      : null,
                                  color: megaobraIconColor(),
                                  icon: const Icon(
                                    Icons.arrow_right,
                                    size: 28,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      scrollController: scrollController,
                      maxDuration: null,
                      startDate: DateTime.now(),
                      dayWidth: dayWidth,
                      eventHeight: 40,
                      stickyAreaWidth: 200,
                      showStickyArea: showStickyArea,
                      stickyAreaEventBuilder: customStickyArea
                          ? (context, eventIndex, event, eventColor) => eventIndex == 0
                              ? Container(
                                  color: Colors.yellow,
                                  child: Center(
                                    child: Text("${AppLocalizations.of(context)!.customWidget}: ${event.displayName}"),
                                  ),
                                )
                              : GanttChartDefaultStickyAreaCell(
                                  event: event,
                                  eventIndex: eventIndex,
                                  eventColor: eventColor,
                                  widgetBuilder: (context) => Text(
                                    "${AppLocalizations.of(context)!.defaultWidgetWithCustomColors}: ${event.displayName}",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : null,
                      weekHeaderBuilder: customWeekHeader
                          ? (context, weekDate) => GanttChartDefaultWeekHeader(
                              weekDate: weekDate,
                              color: Colors.black,
                              backgroundColor: Colors.yellow,
                              border: const BorderDirectional(
                                end: BorderSide(color: Colors.green),
                              ))
                          : null,
                      dayHeaderBuilder: customDayHeader
                          ? (context, date, bool isHoliday) => GanttChartDefaultDayHeader(
                                date: date,
                                isHoliday: isHoliday,
                                color: isHoliday ? Colors.yellow : Colors.black,
                                backgroundColor: isHoliday ? Colors.grey : Colors.yellow,
                              )
                          : null,
                      showDays: showDaysRow,
                      weekEnds: const {WeekDay.friday, WeekDay.saturday},
                      isExtraHoliday: (context, day) {
                        return DateUtils.isSameDay(DateTime(2022, 7, 1), day);
                      },
                      startOfTheWeek: WeekDay.sunday,
                      events: convertProjectsToGanttEvents(loadedProjects),
                    ),
                  ],
                ),
              ),
              Container(
                height: _containerHeight(
                  convertProjectsToGanttEvents(loadedProjects).length,
                ),
                color: megaobraListBackgroundColors()[1],
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 10),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.contrast,
                  size: 19,
                ),
                const SizedBox(width: 8),
                MegaObraSwitch(
                  value: customDayHeader,
                  onChanged: (v) => mounted
                      ? setState(
                          () => customDayHeader = v,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.showWeeekDays,
                  size: 19,
                ),
                const SizedBox(width: 8),
                MegaObraSwitch(
                  value: showDaysRow,
                  onChanged: (v) => mounted
                      ? setState(
                          () => showDaysRow = v,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.showProjects,
                  size: 19,
                ),
                const SizedBox(width: 8),
                MegaObraSwitch(
                  value: showStickyArea,
                  onChanged: (v) => mounted
                      ? setState(
                          () => showStickyArea = v,
                        )
                      : null,
                )
              ],
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: onZoomOut,
              icon: const Icon(Icons.zoom_out),
              color: megaobraIconColor(),
              iconSize: 30,
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: onZoomIn,
              icon: const Icon(Icons.zoom_in),
              color: megaobraIconColor(),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
