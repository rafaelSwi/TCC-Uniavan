import 'package:MegaObra/screens/manager/view/gantt_project.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/crud/compact/project.dart';
import 'package:MegaObra/screens/manager/view/project.dart';
import 'package:MegaObra/models/compact/project.dart';
import 'package:intl/intl.dart';

class MegaObraSimpleProjectListWidget extends StatefulWidget {
  int? filterByUserId;
  MegaObraSimpleProjectListWidget({super.key, this.filterByUserId});

  @override
  MegaObraSimpleProjectListWidgetState createState() => MegaObraSimpleProjectListWidgetState();
}

class MegaObraSimpleProjectListWidgetState extends State<MegaObraSimpleProjectListWidget> {
  bool ableToNavigate = true;
  List<ProjectSuperSimplified> projects = [];

  Future<void> getProjects() async {
    if (!mounted) {
      return;
    }
    List<ProjectSuperSimplified> project_list = await getProjectsCloseToDeadline(context, widget.filterByUserId);
    if (mounted) {
      setState(() {
        projects = project_list;
      });
    }
  }

  void viewProjectNavigator(int project_id) async {
    setState(() {
      ableToNavigate = false;
    });
    ProjectCompactView? projectCompactView = await getCompactProjectById(context, project_id);
    try {
      if (projectCompactView != null && mounted) {
        setState(() {
          ableToNavigate = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministratorProjectViewer(projectCompactView: projectCompactView!),
          ),
        );
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.unableToCollectRequiredInfoFromServer,
        );
      }
    } catch (e) {
      print("e: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorOpeningProject,
        );
      }
    }
    if (mounted) {
      setState(() {
        ableToNavigate = true;
      });
    }
  }

  Color getDateColor(DateTime dateTime) {
    DateTime now = DateTime.now();
    int difference = dateTime.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (difference < 0) {
      return megaobraAlertText();
    } else {
      return megaobraNeutralText();
    }
  }

  IconData getDateIcon(DateTime dateTime) {
    DateTime now = DateTime.now();
    int difference = dateTime.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (difference == 0) {
      return Icons.priority_high;
    }
    if (difference < 0) {
      return Icons.dangerous_outlined;
    }
    return Icons.av_timer;
  }

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: megaobraListBackgroundColors(),
            begin: megaobraListBackgroundGradientdStart(),
            end: megaobraListBackgroundGradientdEnd()),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.unfinishedProjects,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: megaobraNeutralText(),
                ),
              ),
              const Spacer(),
              projects.isEmpty
                  ? Opacity(
                      opacity: 0.3,
                      child: Icon(
                        Icons.power_input,
                        color: megaobraIconColor(),
                      ),
                    )
                  : IconButton(
                      onPressed: () => {
                        if (mounted)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GanttChartFromProjects(
                                  projects: projects,
                                ),
                              ),
                            ),
                          },
                      },
                      icon: Icon(
                        Icons.power_input,
                        color: megaobraIconColor(),
                      ),
                    ),
              const SizedBox(
                width: 5,
              ),
              Opacity(
                opacity: ableToNavigate ? 1.0 : 0.5,
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: megaobraIconColor(),
                  ),
                  onPressed: () {
                    if (mounted && ableToNavigate) {
                      getProjects();
                    }
                  },
                ),
              ),
            ],
          ),
          Divider(
            color: megaobraListDivider(),
            thickness: 2.0,
          ),
          Expanded(
            child: projects.isEmpty
                ? Center(
                    child: Text(
                    AppLocalizations.of(context)!.noUnfinishedProjects,
                    style: TextStyle(color: megaobraNeutralText()),
                  ))
                : ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: megaobraListDivider()),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                formatStringByLength(
                                  project.title.trim(),
                                  16,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: megaobraNeutralText(),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              getDateIcon(project.deadline_date),
                              color: getDateColor(project.deadline_date),
                              size: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.3),
                              child: Text(
                                DateFormat('dd.MM.yy').format(project.deadline_date),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: getDateColor(project.deadline_date),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Opacity(
                              opacity: ableToNavigate ? 1.0 : 0.3,
                              child: IconButton(
                                onPressed: () => {
                                  if (mounted && ableToNavigate)
                                    {
                                      viewProjectNavigator(project.id),
                                    },
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
