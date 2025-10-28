import 'package:MegaObra/crud/compact/project.dart';
import 'package:MegaObra/models/compact/project.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/screens/manager/view/project.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';

class MegaObraDetailedProjectWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<ProjectSuperSimplified> projects;
  final bool showUndone;
  final void Function()? addButtonFunction;

  const MegaObraDetailedProjectWidget({
    super.key,
    required this.label,
    required this.projects,
    this.emptyLabel = "?",
    this.showUndone = true,
    required this.addButtonFunction,
  });

  @override
  MegaObraDetailedProjectWidgetState createState() => MegaObraDetailedProjectWidgetState();
}

class MegaObraDetailedProjectWidgetState extends State<MegaObraDetailedProjectWidget> {
  bool showOnlyOverdueProjects = false;
  bool ableToNavigate = true;

  @override
  void initState() {
    super.initState();
  }

  void showPermissionErrorMessage(BuildContext context) {
    if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.permissionError,
        text: AppLocalizations.of(context)!.notPossibleToCreateProject,
      );
    }
  }

  void viewProjectNavigator(ProjectSuperSimplified project) async {
    setState(() {
      ableToNavigate = false;
    });
    ProjectCompactView? collected_project = await getCompactProjectById(
      context,
      project.id,
    );
    if (collected_project != null) {
      if (mounted) {
        setState(() {
          ableToNavigate = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministratorProjectViewer(
              projectCompactView: collected_project,
            ),
          ),
        );
      }
    }
    if (mounted) {
      setState(() {
        ableToNavigate = true;
      });
    }
  }

  IconData getIcon(DateTime dateTime, DateTime? deactivationDate) {
    if (isDateTimePassed(dateTime)) {
      return Icons.dangerous_outlined;
    } else if (deactivationDate != null) {
      return Icons.done_all;
    } else {
      return Icons.av_timer;
    }
  }

  Color getIconAndTextColor(ProjectSuperSimplified project) {
    if (isDateTimePassed(project.deadline_date)) {
      return megaobraAlertText();
    } else {
      return megaobraNeutralText();
    }
  }

  bool isDateTimePassed(DateTime dateTime) {
    return DateTime.now().isAfter(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    List<ProjectSuperSimplified> filteredProjects = showOnlyOverdueProjects
        ? widget.projects
            .where(
              (project) => isDateTimePassed(project.deadline_date),
            )
            .toList()
        : widget.projects;

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
      child: Column(
        children: [
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
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.showOnlyOverdueProjects,
                    style: TextStyle(color: megaobraNeutralText(), fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  MegaObraSwitch(
                    value: showOnlyOverdueProjects,
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          showOnlyOverdueProjects = value;
                        });
                      }
                    },
                  ),
                ],
              ),
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
                  "${AppLocalizations.of(context)!.startDate} / ${AppLocalizations.of(context)!.deadlineDate} / ${AppLocalizations.of(context)!.projectTitle}",
                  style: TextStyle(
                    color: megaobraNeutralText(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: filteredProjects.isEmpty
                ? Center(
                    child: Text(
                    widget.emptyLabel,
                    style: TextStyle(color: megaobraNeutralText()),
                  ))
                : ListView.builder(
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: megaobraListDivider()),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                getIcon(project.deadline_date, project.deactivation_date),
                                color: getIconAndTextColor(project),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "${formatDateTime(
                                    dateTime: project.start_date,
                                  )} - ${formatDateTime(
                                    dateTime: project.deadline_date,
                                  )}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getIconAndTextColor(project),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            MegaObraDefaultText(
                              text: formatStringByLength(
                                project.title,
                                32,
                              ),
                              size: 20,
                            ),
                            Opacity(
                              opacity: ableToNavigate ? 1.0 : 0.5,
                              child: IconButton(
                                onPressed: () => {
                                  if (mounted && ableToNavigate)
                                    {
                                      viewProjectNavigator(project),
                                    }
                                },
                                icon: Icon(
                                  Icons.format_list_bulleted,
                                  color: megaobraIconColor(),
                                  size: 20,
                                ),
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
    );
  }
}
