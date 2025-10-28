import 'package:MegaObra/screens/app_settings/general.dart';
import 'package:MegaObra/screens/manager/main/activity.dart';
import 'package:MegaObra/screens/manager/main/guide.dart';
import 'package:MegaObra/screens/manager/main/location.dart';
import 'package:MegaObra/screens/manager/main/material.dart';
import 'package:MegaObra/screens/manager/main/project.dart';
import 'package:MegaObra/screens/manager/main/schedule.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/screens/manager/main/user.dart';
import 'package:MegaObra/screens/manager/view/spreadsheet.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/list/simple/project.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/buttons/default.dart';

class MainAdministratorPage extends StatefulWidget {
  const MainAdministratorPage({super.key});

  @override
  State<MainAdministratorPage> createState() => _MainAdministratorPageState();
}

class _MainAdministratorPageState extends State<MainAdministratorPage> {
  String getLoggedUserFirstName() {
    User? logged_user = getLoggedUser();
    if (logged_user != null) {
      return logged_user.name.split(' ').first;
    } else {
      return "NO_USER_LOGGED";
    }
  }

  final double defaultButtonHeight = 50;
  final double defaultButtonWidth = 380;
  final defaultButtonPadding = const EdgeInsets.all(10.0);

  @override
  void dispose() {
    super.dispose();
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
              Container(
                padding: const EdgeInsets.all(14.0),
                child: MegaObraDefaultText(text: "${AppLocalizations.of(context)!.welcome}, ${getLoggedUserFirstName()}."),
              ),
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      if ([1, 2].contains(getLoggedUser()?.permission_id))
                        // MegaObraButton(
                        //   width: defaultButtonWidth,
                        //   height: defaultButtonHeight,
                        //   text: AppLocalizations.of(context)!.activities,
                        //   function: () => {
                        //     if (mounted)
                        //       {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => const FullActivityViewer(),
                        //           ),
                        //         ),
                        //       },
                        //   },
                        //   padding: defaultButtonPadding,
                        //   icon: Icons.construction,
                        //),
                        MegaObraButton(
                          width: defaultButtonWidth,
                          height: defaultButtonHeight,
                          text: AppLocalizations.of(context)!.projects,
                          function: () => {
                            if (mounted)
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FullProjectViewer(),
                                  ),
                                ),
                              },
                          },
                          padding: defaultButtonPadding,
                          icon: Icons.featured_play_list,
                        ),
                      if ([1, 2].contains(getLoggedUser()?.permission_id))
                        MegaObraButton(
                          width: defaultButtonWidth,
                          height: defaultButtonHeight,
                          text: AppLocalizations.of(context)!.locations,
                          function: () => {
                            if (mounted)
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FullLocationViewer(),
                                  ),
                                ),
                              },
                          },
                          padding: defaultButtonPadding,
                          icon: Icons.location_on,
                        ),
                      MegaObraButton(
                        width: defaultButtonWidth,
                        height: defaultButtonHeight,
                        text: AppLocalizations.of(context)!.materials,
                        function: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FullMaterialViewer(),
                                ),
                              ),
                            },
                        },
                        padding: defaultButtonPadding,
                        icon: Icons.bubble_chart,
                      ),
                      MegaObraButton(
                        width: defaultButtonWidth,
                        height: defaultButtonHeight,
                        text: [1, 2].contains(getLoggedUser()?.permission_id)
                            ? AppLocalizations.of(context)!.users
                            : AppLocalizations.of(context)!.profile,
                        function: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const [1, 2].contains(getLoggedUser()?.permission_id)
                                      ? const FullUserViewer()
                                      : AdministratorUserViewer(
                                          user: getLoggedUser()!,
                                          spectate: true,
                                        ),
                                ),
                              ),
                            },
                        },
                        padding: defaultButtonPadding,
                        icon:
                            [1, 2].contains(getLoggedUser()?.permission_id) ? Icons.person_search_rounded : Icons.person_rounded,
                      ),
                      if ([1, 2].contains(getLoggedUser()?.permission_id))
                        MegaObraButton(
                          width: defaultButtonWidth,
                          height: defaultButtonHeight,
                          text: AppLocalizations.of(context)!.schedules,
                          function: () => {
                            if (mounted)
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FullScheduleViewer(),
                                  ),
                                ),
                              },
                          },
                          padding: defaultButtonPadding,
                          icon: Icons.watch_later_outlined,
                        ),
                      // MegaObraButton(
                      //   width: defaultButtonWidth,
                      //   height: defaultButtonHeight,
                      //   text: AppLocalizations.of(context)!.spreadsheetAnalysis,
                      //   function: () => {
                      //     if (mounted)
                      //       {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => SpreadsheetAnalysisView(),
                      //           ),
                      //         ),
                      //       },
                      //   },
                      //   padding: defaultButtonPadding,
                      //   icon: Icons.flip,
                      // ),
                      MegaObraButton(
                        width: defaultButtonWidth,
                        height: defaultButtonHeight,
                        text: AppLocalizations.of(context)!.quickGuide,
                        function: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HowToUseScreen(selectedLang: 0),
                                ),
                              ),
                            },
                        },
                        padding: defaultButtonPadding,
                        icon: Icons.book,
                      ),
                      MegaObraButton(
                        width: defaultButtonWidth,
                        height: defaultButtonHeight,
                        text: AppLocalizations.of(context)!.logout,
                        function: () => {
                          logoutUser(),
                          if (mounted)
                            {
                              Navigator.pop(context),
                            }
                        },
                        padding: defaultButtonPadding,
                        icon: Icons.logout,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 600,
                          width: 350,
                          child: MegaObraSimpleProjectListWidget(
                            filterByUserId: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GeneralSettingsScreen(onExit: null),
              ),
            ).then((_) {
              if (mounted) {
                setState(() {});
              }
            });
          }
        },
        backgroundColor: megaobraButtonBackground(),
        foregroundColor: megaobraColoredText(),
        child: const Icon(Icons.settings),
      ),
    );
  }
}
