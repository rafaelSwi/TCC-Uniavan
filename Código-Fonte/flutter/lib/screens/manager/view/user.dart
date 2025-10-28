import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/crud/schedule.dart';
import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/screens/manager/view/schedule.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/list/simple/activity.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/screens/manager/edit/user/cpf.dart';
import 'package:MegaObra/screens/manager/edit/user/name.dart';
import 'package:MegaObra/screens/manager/edit/user/psw.dart';
import 'package:MegaObra/screens/manager/edit/user/perm.dart';
import 'package:MegaObra/screens/manager/edit/user/role.dart';
import 'package:MegaObra/screens/manager/edit/user/schedule.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/widgets/list/simple/project.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class AdministratorUserViewer extends StatefulWidget {
  User user;
  final bool spectate;
  AdministratorUserViewer({
    super.key,
    required this.user,
    required this.spectate,
  });

  @override
  State<AdministratorUserViewer> createState() => _AdministratorUserViewerState();
}

class _AdministratorUserViewerState extends State<AdministratorUserViewer> {
  int selector = 0;
  List<Activity> loadedActivities = [];
  double lowerButtonDefaultHeight = 33;
  double lowerButtonDefaultwWidth = 300;
  EdgeInsets lowerButtonDefaultPadding = const EdgeInsets.all(4.0);
  bool ableToNavigateToSchedule = true;

  @override
  void initState() {
    super.initState();
    collectActivities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshUser() async {
    if (mounted) {
      User? collectedUser = await getUserById(context, widget.user.id);
      if (collectedUser != null) {
        if (mounted) {
          setState(() {
            widget.user = collectedUser;
          });
        }
      }
    }
  }

  String formatRole(int role_id, BuildContext context) {
    switch (role_id) {
      case 1:
        return AppLocalizations.of(context)!.professional.toUpperCase();
      case 2:
        return AppLocalizations.of(context)!.labourer.toUpperCase();
      case 3:
        return AppLocalizations.of(context)!.assistant.toUpperCase();
      default:
        return AppLocalizations.of(context)!.undefined.toUpperCase();
    }
  }

  String formatPermission(int permission_id, BuildContext context) {
    switch (permission_id) {
      case 1:
        return AppLocalizations.of(context)!.admin.toUpperCase();
      case 2:
        return AppLocalizations.of(context)!.manager.toUpperCase();
      case 3:
        return AppLocalizations.of(context)!.worker.toUpperCase();
      case 4:
        return AppLocalizations.of(context)!.restricted.toUpperCase();
      default:
        return AppLocalizations.of(context)!.unknown.toUpperCase();
    }
  }

  void collectActivities() async {
    if (!mounted) {
      return;
    }
    if ([1, 2].contains(getLoggedUser()?.permission_id) && !widget.spectate) {
      var collectedActivities = await getAssociatedActivitiesByUserId(context, widget.user.id);
      if (mounted) {
        setState(() {
          loadedActivities = collectedActivities;
        });
      }
    }
  }

  Future<Schedule?> getSchedule(int schedule_id) async {
    if (mounted) {
      return getScheduleById(context, schedule_id);
    }
  }

  void viewScheduleNavigator(int schedule_id) async {
    setState(() {
      ableToNavigateToSchedule = false;
    });
    Schedule? schedule = await getSchedule(schedule_id);
    if (schedule != null && mounted) {
      setState(() {
        ableToNavigateToSchedule = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdministratorScheduleViewer(schedule: schedule),
        ),
      );
    } else if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.error,
        text: AppLocalizations.of(context)!.errorWhileOpeningUserSchedule,
      );
    }
    if (mounted) {
      setState(() {
        ableToNavigateToSchedule = true;
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
                  MegaObraRefreshButton(onPressed: refreshUser),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          color: megaobraIconColor(),
                          size: 80,
                          Icons.person,
                        ),
                        const SizedBox(width: 25),
                        MegaObraDefaultText(
                          text: widget.user.name,
                          size: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    MegaObraInformationContainer(
                      text: AppLocalizations.of(context)!.cpf.toUpperCase(),
                      sideText: formatCPF(widget.user.cpf),
                    ),
                    const SizedBox(height: 20),
                    MegaObraInformationContainer(
                      text: AppLocalizations.of(context)!.role.toUpperCase(),
                      sideText: formatRole(widget.user.role_id, context),
                    ),
                    const SizedBox(height: 20),
                    MegaObraInformationContainer(
                      text: AppLocalizations.of(context)!.permission.toUpperCase(),
                      sideText: formatPermission(widget.user.permission_id, context),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        [1, 2].contains(getLoggedUser()?.permission_id) && !widget.spectate
                            ? Column(
                                children: [
                                  Opacity(
                                    opacity: ableToNavigateToSchedule ? 1.0 : 0.5,
                                    child: MegaObraButton(
                                      width: lowerButtonDefaultwWidth,
                                      height: lowerButtonDefaultHeight,
                                      icon: Icons.watch_later,
                                      text: AppLocalizations.of(context)!.schedules,
                                      padding: lowerButtonDefaultPadding,
                                      function: () => {
                                        if (mounted && ableToNavigateToSchedule)
                                          {
                                            viewScheduleNavigator(
                                              widget.user.schedule_id,
                                            ),
                                          },
                                      },
                                    ),
                                  ),
                                  MegaObraButton(
                                    width: lowerButtonDefaultwWidth,
                                    height: lowerButtonDefaultHeight,
                                    icon: Icons.edit,
                                    text: AppLocalizations.of(context)!.changeSchedule,
                                    padding: lowerButtonDefaultPadding,
                                    function: () => {
                                      if (mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUserScheduleScreen(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),
                                        },
                                    },
                                  ),
                                  MegaObraButton(
                                    width: lowerButtonDefaultwWidth,
                                    height: lowerButtonDefaultHeight,
                                    icon: Icons.edit,
                                    text: AppLocalizations.of(context)!.changeRole,
                                    padding: lowerButtonDefaultPadding,
                                    function: () => {
                                      if (mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUserRoleScreen(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),
                                        },
                                    },
                                  ),
                                  MegaObraButton(
                                    width: lowerButtonDefaultwWidth,
                                    height: lowerButtonDefaultHeight,
                                    icon: Icons.edit,
                                    text: AppLocalizations.of(context)!.changePermissions,
                                    padding: lowerButtonDefaultPadding,
                                    function: () => {
                                      if (mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUserPermissionScreen(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),
                                        },
                                    },
                                  ),
                                  MegaObraButton(
                                    width: lowerButtonDefaultwWidth,
                                    height: lowerButtonDefaultHeight,
                                    icon: Icons.edit,
                                    text: AppLocalizations.of(context)!.changeName,
                                    padding: lowerButtonDefaultPadding,
                                    function: () => {
                                      if (mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUserNameScreen(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),
                                        },
                                    },
                                  ),
                                  MegaObraButton(
                                    width: lowerButtonDefaultwWidth,
                                    height: lowerButtonDefaultHeight,
                                    icon: Icons.edit,
                                    text: AppLocalizations.of(context)!.changeCpf,
                                    padding: lowerButtonDefaultPadding,
                                    function: () => {
                                      if (mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUserCpfScreen(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),
                                        },
                                    },
                                  ),
                                  Center(
                                    child: MegaObraButton(
                                      width: lowerButtonDefaultwWidth,
                                      height: lowerButtonDefaultHeight,
                                      icon: Icons.edit,
                                      text: AppLocalizations.of(context)!.resetPassword,
                                      padding: lowerButtonDefaultPadding,
                                      function: () => {
                                        if (mounted)
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditUserPasswordScreen(
                                                  user: widget.user,
                                                ),
                                              ),
                                            ),
                                          },
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(
                                width: 0,
                              ),
                        const SizedBox(
                          width: 100,
                        ),
                        [1, 2].contains(getLoggedUser()?.permission_id) && !widget.spectate
                            ? Row(
                                children: [
                                  if (selector == 0)
                                    SizedBox(
                                      height: 300,
                                      width: 350,
                                      child: MegaObraSimpleActivityListWidget(
                                        label: AppLocalizations.of(context)!.associatedActivities,
                                        activities: loadedActivities,
                                        ableToNavigate: true,
                                        emptyLabel: AppLocalizations.of(context)!.noActivitiesFound,
                                      ),
                                    )
                                  else if (selector == 1)
                                    SizedBox(
                                      height: 300,
                                      width: 350,
                                      child: MegaObraSimpleProjectListWidget(
                                        filterByUserId: widget.user.id,
                                      ),
                                    ),
                                  const SizedBox(width: 20),
                                  Column(
                                    children: [
                                      Opacity(
                                        opacity: selector == 0 ? 1.0 : 0.3,
                                        child: Icon(
                                          Icons.lens,
                                          color: megaobraIconColor(),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Opacity(
                                        opacity: selector == 0 ? 0.3 : 1.0,
                                        child: Icon(
                                          Icons.lens,
                                          color: megaobraIconColor(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      IconButton(
                                        onPressed: () => {
                                          if (mounted)
                                            {
                                              setState(
                                                () {
                                                  selector == 0 ? selector = 1 : selector = 0;
                                                },
                                              ),
                                            }
                                        },
                                        icon: Icon(
                                          Icons.loop,
                                          color: megaobraIconColor(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(
                                width: 0,
                              ),
                      ],
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
