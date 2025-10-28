import 'package:MegaObra/crud/project.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/screens/manager/create/project.dart';
import 'package:MegaObra/widgets/list/detailed/project.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class FullProjectViewer extends StatefulWidget {
  const FullProjectViewer({
    super.key,
  });

  @override
  State<FullProjectViewer> createState() => _FullProjectViewerState();
}

class _FullProjectViewerState extends State<FullProjectViewer> {
  late Future<List<ProjectSuperSimplified>> futureProjects;

  @override
  void initState() {
    super.initState();
    futureProjects = collectProjects();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<ProjectSuperSimplified>> collectProjects() async {
    if (mounted) {
      List<ProjectSuperSimplified>? projects = await getProjectsCloseToDeadline(
        context,
        null,
      );
      return projects ?? [];
    }
    return [];
  }

  void refreshProjects() {
    if (mounted) {
      setState(() {
        futureProjects = collectProjects();
      });
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const MegaObraNavigatorPopButton(),
                  MegaObraRefreshButton(onPressed: refreshProjects),
                ],
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30.0),
                height: 600,
                width: 800,
                child: FutureBuilder<List<ProjectSuperSimplified>>(
                  future: futureProjects,
                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return MegaObraDetailedProjectWidget(
                        label: AppLocalizations.of(context)!.projects,
                        projects: snapshot.data!,
                        emptyLabel: AppLocalizations.of(context)!.noProjects,
                        showUndone: false,
                        addButtonFunction: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateProjectScreen(),
                                ),
                              ),
                            },
                        },
                      );
                    } else {
                      return Text(
                        AppLocalizations.of(context)!.noProjects,
                        style: TextStyle(
                          color: megaobraNeutralText(),
                        ),
                      );
                    }
                  },
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
