import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/screens/manager/create/activity.dart';
import 'package:MegaObra/screens/manager/edit/activity.dart';
import 'package:MegaObra/screens/manager/edit/chunk.dart';
import 'package:MegaObra/screens/manager/edit/selection/activities.dart';
import 'package:MegaObra/screens/manager/edit/selection/users.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/list/simple/activity.dart';
import 'package:MegaObra/widgets/list/simple/employee.dart';
import 'package:MegaObra/widgets/list/simple/material.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/screens/manager/view/location.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class AdministratorActivityViewer extends StatefulWidget {
  Activity activity;
  final Location activityLocation;
  final bool hideButtons;
  final bool forceHighPermission;

  AdministratorActivityViewer({
    super.key,
    required this.hideButtons,
    required this.activity,
    required this.activityLocation,
    required this.forceHighPermission,
  });

  @override
  State<AdministratorActivityViewer> createState() => _AdministratorActivityViewerState();
}

class _AdministratorActivityViewerState extends State<AdministratorActivityViewer> {
  final double megaobraInfoMaxWidth = 250.0;
  final double megaobraInfoMaxHeight = 40.0;
  final double megaobraBelowButtonWidth = 330.0;
  String _selectedView = '';
  bool ableToNavigateToLocation = true;
  bool ableToNavigateToCreator = true;
  List<Activity> _loadedRestrictions = [];
  List<User> _loadedEmployees = [];
  List<model.Material> _loadedMaterials = [];

  Future<void> collectActivityRestrictionsAndEmployees() async {
    try {
      if (mounted) {
        List<Activity> activity_rest_list = await getActivityRestrictions(context, widget.activity.id);
        List<User> activity_emp_list = await getActivityEmployees(context, widget.activity.id);
        List<model.Material> activity_material_list = await getActivityMaterials(context, widget.activity.id);
        if (mounted) {
          setState(() {
            _loadedRestrictions = activity_rest_list;
            _loadedEmployees = activity_emp_list;
            _loadedMaterials = activity_material_list;
          });
        }
      }
    } catch (e) {
      print("Error: ${e}");
    }
  }

  Widget getSelectedView(BuildContext context) {
    var restrictionsLabel = AppLocalizations.of(context)!.restrictions;
    var empLabel = AppLocalizations.of(context)!.employees;

    if (_selectedView == restrictionsLabel) {
      return Container(
        child: MegaObraSimpleActivityListWidget(
          maxStringSize: 58,
          label: restrictionsLabel,
          activities: _loadedRestrictions,
          ableToNavigate: !widget.hideButtons,
          emptyLabel: AppLocalizations.of(context)!.noActivitiesFound,
        ),
      );
    } else if (_selectedView == empLabel) {
      return MegaObraSimpleEmployeeListWidget(
        label: AppLocalizations.of(context)!.employees,
        employees: _loadedEmployees,
        ableToNavigate: !widget.hideButtons,
      );
    } else {
      return MegaObraSimpleMaterialListWidget(
        label: AppLocalizations.of(context)!.materials,
        materials: _loadedMaterials,
        ableToNavigate: !widget.hideButtons,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    collectActivityRestrictionsAndEmployees();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void viewUserNavigator(int user_id) async {
      if (!mounted) {
        return;
      }
      setState(() {
        ableToNavigateToCreator = false;
      });
      User? collectedUser = await getUserById(context, user_id);
      try {
        if (collectedUser != null) {
          if (mounted) {
            setState(() {
              ableToNavigateToCreator = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdministratorUserViewer(
                  user: collectedUser!,
                  spectate: false,
                ),
              ),
            );
          }
        } else if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorOpeningUser,
          );
        }
      } catch (e) {
        print("e: ${e}");
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorOpeningUser,
          );
        }
      }
      if (mounted) {
        setState(() {
          ableToNavigateToCreator = true;
        });
      }
    }

    void reloadActivity() async {
      if (!mounted) {
        return;
      }
      Activity? activity = await getActivityById(context, widget.activity.id);
      if (activity != null) {
        if (mounted) {
          setState(() {
            widget.activity = activity;
          });
        }
      }
    }

    void viewEditActivityNavigator() {
      try {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditActivityScreen(
                activity: widget.activity,
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
            text: AppLocalizations.of(context)!.errorWhileUpdatingActivity,
          );
        }
      }
    }

    void viewLocationNavigator(int location_id) async {
      if (!mounted) {
        return;
      }
      setState(() {
        ableToNavigateToLocation = false;
      });
      Location? collectedLocation = await getLocationById(context, location_id);
      try {
        if (collectedLocation != null) {
          if (mounted) {
            setState(() {
              ableToNavigateToLocation = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdministratorLocationViewer(location: collectedLocation),
              ),
            );
          }
        } else if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorOpeningLocation,
          );
        }
      } catch (e) {
        print("e: ${e}");
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorOpeningLocation,
          );
        }
      }
      if (mounted) {
        setState(() {
          ableToNavigateToLocation = true;
        });
      }
    }

    void markActivityAsDone(BuildContext context) async {
      try {
        final Map<String, dynamic> updateData = {
          'done': true,
        };
        final response = await updateActivityProperty(
          context,
          widget.activity.id,
          updateData,
        );
        if (response != null) {
          if (mounted) {
            showAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.activity,
              text: AppLocalizations.of(context)!.requestToCompleteActivity,
              pop: true,
            );
          }
        } else if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.activity,
            text: AppLocalizations.of(context)!.errorWhileCompletingActivityCheckForMore,
          );
        }
      } catch (e) {
        print("Error while trying to update a activity property: ${e}");
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorWhileCompletingActivity,
          );
        }
      }
    }

    void showPermissionErrorMessage() {
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.permissionError,
          text: AppLocalizations.of(context)!.youDontHavePerm,
        );
      }
    }

    bool isDoneButtonDisabled() {
      if (widget.activity.done) {
        return true;
      } else {
        return false;
      }
    }

    void reloadUsers() async {
      if (!mounted) {
        return;
      }
      List<User> activity_emp_list = await getActivityEmployees(context, widget.activity.id);
      if (mounted) {
        setState(() {
          _loadedEmployees = activity_emp_list;
        });
      }
    }

    void reloadRestrictions() async {
      if (!mounted) {
        return;
      }
      List<Activity> activity_res_list = await getActivityRestrictions(context, widget.activity.id);
      if (mounted) {
        setState(() {
          _loadedRestrictions = activity_res_list;
        });
      }
    }

    void reloadMaterials() async {
      if (!mounted) {
        return;
      }
      List<model.Material> activity_mat_list = await getActivityMaterials(context, widget.activity.id);
      if (mounted) {
        setState(() {
          _loadedMaterials = activity_mat_list;
        });
      }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const MegaObraNavigatorPopButton(),
                  MegaObraRefreshButton(onPressed: reloadActivity),
                ],
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30.0),
                height: 120,
                width: 800,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      color: megaobraIconColor(),
                      size: 60.0,
                      Icons.construction,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    MegaObraDefaultText(
                      text: formatStringByLength(
                        widget.activity.description,
                        34,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          bottom: 5.0,
                          left: 30.0,
                        ),
                        child: Row(
                          children: [
                            MegaObraInformationContainer(
                              text: AppLocalizations.of(context)!.averagePrice,
                              maxWidth: 400,
                              containerHeight: 40,
                              sideText: "R\$ ${widget.activity.average_labor_cost}",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 5.0,
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            MegaObraInformationContainer(
                              text: AppLocalizations.of(context)!.enterprise,
                              maxWidth: 400,
                              containerHeight: 40,
                              sideText: formatStringByLength(
                                widget.activityLocation.enterprise,
                                18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 5.0,
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            MegaObraInformationContainer(
                              text: AppLocalizations.of(context)!.created,
                              maxWidth: 400,
                              containerHeight: 40,
                              sideText: formatStringByLength(
                                formatDateTime(
                                  dateTime: widget.activity.creation_date,
                                  nullText: AppLocalizations.of(context)!.inProgressAbbreviated,
                                ),
                                18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 5.0,
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            MegaObraInformationContainer(
                              text: AppLocalizations.of(context)!.startDate,
                              maxWidth: 400,
                              containerHeight: 40,
                              sideText: formatStringByLength(
                                formatDateTime(
                                  dateTime: widget.activity.start_date,
                                  nullText: "...",
                                ),
                                18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 5.0,
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            MegaObraInformationContainer(
                              text: AppLocalizations.of(context)!.deadlineDate,
                              maxWidth: 400,
                              containerHeight: 40,
                              sideText: formatStringByLength(
                                formatDateTime(
                                  dateTime: widget.activity.deadline_date,
                                  nullText: "...",
                                ),
                                18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 5.0,
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            MegaObraInformationContainer(
                              text: AppLocalizations.of(context)!.done,
                              maxWidth: 400,
                              containerHeight: 40,
                              sideText: formatStringByLength(
                                formatDateTime(
                                  dateTime: widget.activity.done_date,
                                  nullText: AppLocalizations.of(context)!.inProgressAbbreviated,
                                ),
                                18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 315,
                        width: 350,
                        child: getSelectedView(context),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Opacity(
                            opacity: _selectedView == AppLocalizations.of(context)!.employees ? 1.0 : 0.3,
                            child: Icon(
                              Icons.lens,
                              color: megaobraIconColor(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Opacity(
                            opacity: _selectedView == AppLocalizations.of(context)!.restrictions ? 1.0 : 0.3,
                            child: Icon(
                              Icons.lens,
                              color: megaobraIconColor(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Opacity(
                            opacity: _selectedView == AppLocalizations.of(context)!.materials ? 1.0 : 0.3,
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
                                      final employees = AppLocalizations.of(context)!.employees;
                                      final restrictions = AppLocalizations.of(context)!.restrictions;
                                      final materials = AppLocalizations.of(context)!.materials;

                                      final order = [employees, restrictions, materials];
                                      final currentIndex = order.indexOf(_selectedView);
                                      final nextIndex = (currentIndex + 1) % order.length;

                                      _selectedView = order[nextIndex];
                                    },
                                  ),
                                }
                            },
                            icon: Icon(
                              Icons.loop,
                              color: megaobraIconColor(),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (!widget.hideButtons)
                            Opacity(
                              opacity: widget.hideButtons ? 0.3 : 1.0,
                              child: IconButton(
                                onPressed: () => {
                                  if (_selectedView == AppLocalizations.of(context)!.restrictions)
                                    {
                                      if (mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ActivitySelectionPage(
                                                selectedActivityIds: _loadedRestrictions.map((obj) => obj.id).toList(),
                                                onApply: (values) async {
                                                  await updateActivityRestrictions(
                                                    context,
                                                    widget.activity.id,
                                                    values,
                                                  );
                                                  reloadRestrictions();
                                                },
                                              ),
                                            ),
                                          ),
                                        },
                                    }
                                  else if ((mounted && [1, 2].contains(getLoggedUser()?.id)) ||
                                      (mounted && widget.forceHighPermission))
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserSelectionPage(
                                            onApply: (values) async {
                                              await updateActivityEmployees(
                                                context,
                                                widget.activity.id,
                                                values,
                                              );
                                              reloadUsers();
                                            },
                                            selectedUserIds: _loadedEmployees.map((obj) => obj.id).toList(),
                                          ),
                                        ),
                                      ),
                                    },
                                },
                                icon: Opacity(
                                  opacity: [1, 2].contains(getLoggedUser()?.id) || widget.forceHighPermission ? 1.0 : 0.1,
                                  child: Icon(
                                    Icons.edit,
                                    color: megaobraIconColor(),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 5.0,
                      right: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.professionals,
                          maxWidth: megaobraInfoMaxWidth,
                          containerHeight: megaobraInfoMaxHeight,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.amount}: ${widget.activity.professional_amount}",
                          maxWidth: megaobraInfoMaxWidth,
                          containerHeight: megaobraInfoMaxHeight,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.time}: ${widget.activity.professional_minutes}m",
                          maxWidth: megaobraInfoMaxWidth,
                          containerHeight: megaobraInfoMaxHeight,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 5.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.labourers,
                          maxWidth: megaobraInfoMaxWidth,
                          containerHeight: megaobraInfoMaxHeight,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.amount}: ${widget.activity.laborer_amount}",
                          maxWidth: megaobraInfoMaxWidth,
                          containerHeight: megaobraInfoMaxHeight,
                        ),
                        MegaObraInformationContainer(
                          text: "${AppLocalizations.of(context)!.time}: ${widget.activity.laborer_minutes}m",
                          maxWidth: megaobraInfoMaxWidth,
                          containerHeight: megaobraInfoMaxHeight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.hideButtons == false)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MegaObraButton(
                          width: megaobraBelowButtonWidth,
                          height: 35,
                          text: AppLocalizations.of(context)!.viewProgress,
                          icon: Icons.border_bottom,
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 30.0,
                            bottom: 4.0,
                            right: 30.0,
                          ),
                          function: () => {
                            if (mounted)
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChunkGroupingScreen(
                                      location_id: widget.activity.location_id,
                                      activity_id: widget.activity.id,
                                      title: widget.activity.description,
                                    ),
                                  ),
                                ),
                              },
                          },
                        ),
                        MegaObraButton(
                          icon: Icons.theater_comedy_sharp,
                          width: megaobraBelowButtonWidth,
                          height: 35,
                          text: AppLocalizations.of(context)!.cloneActivity,
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            bottom: 4.0,
                            right: 30.0,
                          ),
                          function: () => {
                            if ([1, 2].contains(getLoggedUser()?.permission_id))
                              {
                                if (mounted)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateActivityScreen(
                                          referenceActivity: widget.activity,
                                        ),
                                      ),
                                    ),
                                  },
                              }
                            else if (mounted)
                              {
                                showAlertDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!.permError,
                                  text: AppLocalizations.of(context)!.cantCloneActivity,
                                )
                              }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: ableToNavigateToCreator ? 1.0 : 0.5,
                          child: MegaObraButton(
                            icon: Icons.manage_accounts,
                            width: megaobraBelowButtonWidth,
                            height: 35,
                            text: AppLocalizations.of(context)!.creatorInformation,
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 30.0,
                              bottom: 4.0,
                              right: 30.0,
                            ),
                            function: () => {
                              if (mounted && ableToNavigateToCreator)
                                {
                                  viewUserNavigator(
                                    widget.activity.created_by,
                                  ),
                                }
                            },
                          ),
                        ),
                        MegaObraButton(
                          icon: Icons.edit_document,
                          width: megaobraBelowButtonWidth,
                          height: 35,
                          text: AppLocalizations.of(context)!.modifyActivityAttributes,
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            bottom: 4.0,
                            right: 30.0,
                          ),
                          function: () => {
                            if (!widget.activity.done)
                              {
                                [1, 2].contains(getLoggedUser()?.permission_id) || widget.forceHighPermission
                                    ? viewEditActivityNavigator()
                                    : showPermissionErrorMessage(),
                              }
                            else if (mounted)
                              {
                                showAlertDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!.activityAlreadyDone,
                                  text: AppLocalizations.of(context)!.cannotModifyActivitiesThatHaveAlreadyBeenCompleted,
                                )
                              }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: ableToNavigateToLocation ? 1.0 : 0.5,
                          child: MegaObraButton(
                            icon: Icons.location_on,
                            width: megaobraBelowButtonWidth,
                            height: 35,
                            text: AppLocalizations.of(context)!.locationInformation,
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              bottom: 30.0,
                              right: 30.0,
                              top: 10.0,
                            ),
                            function: () => {
                              if (mounted && ableToNavigateToLocation)
                                {
                                  viewLocationNavigator(
                                    widget.activity.location_id,
                                  ),
                                }
                            },
                          ),
                        ),
                        MegaObraButton(
                          icon: Icons.done_all,
                          width: megaobraBelowButtonWidth,
                          height: 35,
                          text: isDoneButtonDisabled()
                              ? AppLocalizations.of(context)!.activityAlreadyDone
                              : AppLocalizations.of(context)!.markDone,
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            bottom: 30.0,
                            right: 30.0,
                            top: 10.0,
                          ),
                          function: () => {
                            [1, 2].contains(getLoggedUser()?.permission_id) || widget.forceHighPermission
                                ? isDoneButtonDisabled()
                                    ? null
                                    : mounted
                                        ? markActivityAsDone(context)
                                        : null
                                : showPermissionErrorMessage(),
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
