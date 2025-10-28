import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/screens/manager/view/schedule.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';

class MegaObraDetailedScheduleListWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<ScheduleCompact> schedules;
  final void Function()? addButtonFunction;

  const MegaObraDetailedScheduleListWidget({
    super.key,
    required this.label,
    required this.schedules,
    this.emptyLabel = "?",
    required this.addButtonFunction,
  });

  @override
  MegaObraDetailedScheduleListWidgetState createState() => MegaObraDetailedScheduleListWidgetState();
}

class MegaObraDetailedScheduleListWidgetState extends State<MegaObraDetailedScheduleListWidget> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  void showPermissionErrorMessage(BuildContext context) {
    if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.permissionError,
        text: AppLocalizations.of(context)!.notPossibleToCreateSchedule,
      );
    }
  }

  void viewScheduleNavigator(ScheduleCompact s, int userAmount) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdministratorScheduleViewer(
          schedule: Schedule(
            id: s.id,
            schedule_name: s.schedule_name,
            clock_in: s.clock_in,
            clock_out: s.clock_out,
            break_in: s.break_in,
            break_out: s.break_out,
            deprecated: false,
          ),
          userAmount: userAmount,
        ),
      ),
    );
  }

  void applySearch() {
    if (mounted) {
      setState(() {
        searchQuery = searchController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ScheduleCompact> filteredSchedules = widget.schedules
        .where((sc) => (searchQuery.isEmpty || sc.schedule_name.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: megaobraListBackgroundColors(),
          begin: megaobraListBackgroundGradientdStart(),
          end: megaobraListBackgroundGradientdEnd(),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            applySearch();
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: megaobraNeutralOpaqueText(),
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(color: megaobraNeutralOpaqueText()),
                          filled: true,
                          fillColor: Colors.transparent,
                          icon: Icon(
                            Icons.search,
                            color: megaobraNeutralOpaqueText(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: applySearch,
                    icon: const Icon(Icons.search),
                    color: megaobraIconColor(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: [1, 2].contains(getLoggedUser()?.permission_id)
                      ? (mounted ? widget.addButtonFunction : null)
                      : () => showPermissionErrorMessage(context),
                  icon: Icon(
                    Icons.add,
                    color: megaobraNeutralText(),
                  ),
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: megaobraNeutralText(),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Divider(
              color: megaobraListDivider(),
              thickness: 2.0,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                  child: Icon(
                    Icons.info_outline,
                    color: megaobraIconColor(),
                    size: 20,
                  ),
                ),
                Container(
                  width: 400,
                  padding: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                  child: Text(
                    "${AppLocalizations.of(context)!.name} / ${AppLocalizations.of(context)!.usersUsing} / ${AppLocalizations.of(context)!.clockIn} / ${AppLocalizations.of(context)!.workBreaks} (${AppLocalizations.of(context)!.ifAny}) / ${AppLocalizations.of(context)!.clockOut}",
                    style: TextStyle(
                      color: megaobraNeutralText(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: filteredSchedules.isEmpty
                  ? Center(
                      child: Text(
                        widget.emptyLabel,
                        style: TextStyle(
                          color: megaobraNeutralText(),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredSchedules.length,
                      itemBuilder: (context, index) {
                        final schedule = filteredSchedules[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: megaobraListDivider()),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  color: megaobraIconColor(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: SizedBox(
                                  width: 150,
                                  child: Text(
                                    formatStringByLength(
                                      schedule.schedule_name,
                                      20,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: megaobraNeutralText(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const MegaObraDefaultText(
                                text: "|",
                                size: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.people,
                                color: megaobraIconColor(),
                                size: 20,
                              ),
                              SizedBox(
                                width: 60,
                                child: MegaObraDefaultText(
                                  text: schedule.user_amount.toString(),
                                  size: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const MegaObraDefaultText(
                                text: "|",
                                size: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              const Spacer(),
                              MegaObraDefaultText(
                                text: schedule.break_in != null
                                    ? "${schedule.clock_in} - ${schedule.break_in} - ${schedule.break_out} - ${schedule.clock_out}"
                                    : "${schedule.clock_in} - ${schedule.clock_out}",
                                size: 17,
                              ),
                              IconButton(
                                onPressed: () => {
                                  if (mounted)
                                    {
                                      viewScheduleNavigator(
                                        schedule,
                                        schedule.user_amount,
                                      ),
                                    }
                                },
                                icon: Icon(
                                  Icons.format_list_bulleted,
                                  color: megaobraIconColor(),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
