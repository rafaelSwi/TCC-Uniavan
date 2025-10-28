import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/edit/selection/activities.dart';
import 'package:MegaObra/screens/manager/edit/selection/chunks.dart';
import 'package:MegaObra/screens/manager/edit/selection/material.dart';
import 'package:MegaObra/screens/manager/edit/selection/users.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/widgets/datepicker/datepicker.dart';
import 'package:MegaObra/widgets/dropdown/location.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/utils/formatting.dart';

class CreateActivityScreen extends StatefulWidget {
  Activity? referenceActivity;
  int? projectId;
  int? filterRestrictionsByProjectId;
  CreateActivityScreen({super.key, this.referenceActivity, this.projectId, this.filterRestrictionsByProjectId});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final double megaobraInfoMaxWidth = 220.0;
  bool _showDeprecatedLocations = false;
  bool _sameProject = true;
  DateTime? _startDateSelector;
  DateTime? _deadlineSelector;
  DateTime? _persistentStartDate;
  DateTime? _persistentDeadlineDate;
  late TextEditingController _descController;
  late TextEditingController _proAmountController;
  late TextEditingController _proTimeController;
  late TextEditingController _labAmountController;
  late TextEditingController _labTimeController;
  late TextEditingController _averageLabCostController;
  Location? _selectedLocation;
  List<int> _multipleActivities = [];
  List<int> _multipleEmployees = [];
  List<int> _multipleMaterials = [];
  List<double> _multipleMaterialsAmounts = [];
  List<int> _multipleChunks = [];
  List<Activity> _loadedActivities = [];
  List<User> _loadedUsers = [];
  bool rain = false;

  int selector = 0;

  void loadUsers() async {
    if (!mounted) {
      return;
    }
    try {
      var result_users = await getAllUsers(context);
      var result_act = await getAssociatedActivities(context, true);
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _loadedUsers = result_users;
            _loadedActivities = result_act;
          });
        }
      });
    } catch (e) {
      print("Error: ${e}");
    }
  }

  void _handleStartDateSelector(DateTime date) {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _startDateSelector = date;
          _persistentStartDate = date;
        });
      }
    });
  }

  void _handleDeadlineSelector(DateTime date) {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _deadlineSelector = date;
          _persistentDeadlineDate = date;
        });
      }
    });
  }

  List<int> convertActivitiesIntoIntList(List<Activity> activity_list) {
    List<int> return_list = [];
    for (int i = 0; i < activity_list.length; i++) {
      return_list.add(activity_list[i].id);
    }
    return return_list;
  }

  List<int> convertEmployeesIntoIntList(List<User> user_list) {
    List<int> return_list = [];
    for (int i = 0; i < user_list.length; i++) {
      return_list.add(user_list[i].id);
    }
    return return_list;
  }

  Future<List<Activity>> collectActivities() async {
    return await getAssociatedActivities(context, true);
  }

  void _onLocationSelected(Location location) {
    if (mounted) {
      setState(() {
        _multipleChunks = [];
        _selectedLocation = location;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _multipleChunks = [];
    loadUsers();
    _descController = TextEditingController(
      text: widget.referenceActivity?.description,
    );
    _averageLabCostController = TextEditingController(
      text: widget.referenceActivity?.average_labor_cost.toString(),
    );
    _proAmountController = TextEditingController(
      text: widget.referenceActivity?.professional_amount.toString(),
    );
    _proTimeController = TextEditingController(
      text: widget.referenceActivity?.professional_minutes.toString(),
    );
    _labAmountController = TextEditingController(
      text: widget.referenceActivity?.laborer_amount.toString(),
    );
    _labTimeController = TextEditingController(
      text: widget.referenceActivity?.laborer_minutes.toString(),
    );
    if (widget.referenceActivity != null) {
      _handleStartDateSelector(widget.referenceActivity!.start_date);
      _handleDeadlineSelector(widget.referenceActivity!.deadline_date);
      _selectedLocation = Location(
        id: widget.referenceActivity!.location_id,
        enterprise: "",
        cep: "",
        description: "CLONE",
        deprecated: false,
      );
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _proAmountController.dispose();
    _proTimeController.dispose();
    _labAmountController.dispose();
    _labTimeController.dispose();
    super.dispose();
  }

  bool fieldsAreOk() {
    List<String> checks = [
      _descController.text,
      _proAmountController.text,
      _proTimeController.text,
      _labAmountController.text,
      _labTimeController.text,
      _selectedLocation?.description ?? "",
    ];
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] == "") {
        return false;
      }
    }
    if ([_persistentStartDate, _persistentDeadlineDate].contains(null)) {
      return false;
    }
    return true;
  }

  int makeItInt(String text) {
    try {
      return int.parse(text);
    } catch (e) {
      return 0;
    }
  }

  ActivityCreate generateActivityCreate() {
    return ActivityCreate(
      description: _descController.text,
      location_id: _selectedLocation?.id ?? 0,
      start_date: _persistentStartDate ?? DateTime(0),
      deadline_date: _persistentDeadlineDate ?? DateTime(0),
      professional_amount: makeItInt(_proAmountController.text),
      laborer_amount: makeItInt(_labAmountController.text),
      professional_minutes: makeItInt(_proTimeController.text),
      laborer_minutes: makeItInt(_labTimeController.text),
      average_labor_cost: makeItInt(_averageLabCostController.text),
      chunks: _multipleChunks,
      restriction: _multipleActivities,
      employee: _multipleEmployees,
      materials: _multipleMaterials,
      materials_quantity: _multipleMaterialsAmounts,
      project_id: widget.projectId,
      rain: rain,
    );
  }

  ActivityClone generateActivityClone() {
    return ActivityClone(
      description: _descController.text,
      start_date: _persistentStartDate ?? DateTime(0),
      deadline_date: _persistentDeadlineDate ?? DateTime(0),
      professional_amount: makeItInt(_proAmountController.text),
      laborer_amount: makeItInt(_labAmountController.text),
      professional_minutes: makeItInt(_proTimeController.text),
      laborer_minutes: makeItInt(_labTimeController.text),
      average_labor_cost: makeItInt(_averageLabCostController.text),
      restriction: _multipleActivities,
      same_project: _sameProject,
      materials: _multipleMaterials,
      materials_quantity: _multipleMaterialsAmounts,
    );
  }

  void _handleEmployeesSelector(List<User> users) {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _multipleEmployees = users.map((obj) => obj.id).toList();
        });
      }
    });
  }

  int getSelectorTab(int currentTab, bool end, bool back) {
    final hasReference = widget.referenceActivity != null;

    if (!back) {
      if (currentTab == 3) return end ? currentTab : 0;

      int next = currentTab + 1;
      if (hasReference && next == 2) next++;
      return next;
    } else {
      int prev = currentTab - 1;
      if (prev < 0) return 0;

      if (hasReference && prev == 2) prev--;
      return prev < 0 ? 0 : prev;
    }
  }

  void tryToCreateNewActivity(
    BuildContext context,
    ActivityCreate newActivity,
  ) async {
    try {
      if (fieldsAreOk() == false) {
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.emptyFields,
            text: AppLocalizations.of(context)!.fillAllToCreateActivity,
          );
        }
        return;
      }
      if (mounted) {
        await createNewActivity(context, newActivity);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.activity,
          text: AppLocalizations.of(context)!.requestToCreateActivitySent,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to create a activity: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCreatingActivity,
        );
      }
    }
  }

  void tryToCreateCloneActivity(
    BuildContext context,
    ActivityClone clonedActivity,
  ) async {
    try {
      if (fieldsAreOk() == false) {
        if (mounted) {
          showAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.emptyFields,
              text: AppLocalizations.of(context)!.fillAllToCloneActivity);
        }
        return;
      }
      if (mounted) {
        await createNewCloneActivity(context, clonedActivity, widget.referenceActivity?.id ?? 0);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.activity,
          text: AppLocalizations.of(context)!.requestToCloneActivitySent,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to clone a activity: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCloningActivity,
        );
      }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MegaObraNavigatorPopButton(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.referenceActivity == null ? Icons.construction : Icons.theater_comedy_sharp,
                  color: megaobraIconColor(),
                  size: 70,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: widget.referenceActivity == null
                      ? AppLocalizations.of(context)!.createActivity
                      : AppLocalizations.of(context)!.cloneActivity,
                  size: 40,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: 700,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () => {
                          if (mounted)
                            {
                              setState(
                                () {
                                  selector = getSelectorTab(selector, true, true);
                                },
                              ),
                            }
                        },
                        icon: Icon(
                          Icons.arrow_left,
                          color: megaobraIconColor(),
                          size: 40,
                        ),
                        color: megaobraButtonBackground(),
                      ),
                      const SizedBox(width: 30),
                      Text(
                        AppLocalizations.of(context)!.details,
                        style: TextStyle(
                          color: selector == 0 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text(
                        AppLocalizations.of(context)!.materials,
                        style: TextStyle(
                          color: selector == 1 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.referenceActivity == null)
                        Row(
                          children: [
                            const SizedBox(width: 30),
                            Text(
                              AppLocalizations.of(context)!.employees,
                              style: TextStyle(
                                color: selector == 2 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(width: 30),
                      Text(
                        AppLocalizations.of(context)!.restrictions,
                        style: TextStyle(
                          color: selector == 3 ? megaobraNeutralText() : megaobraNeutralOpaqueText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Opacity(
                        opacity: selector == 4 ? 0.3 : 1.0,
                        child: IconButton(
                          onPressed: () => {
                            Future.microtask(() {
                              if (fieldsAreOk()) {
                                if (mounted) {
                                  setState(() {
                                    selector = getSelectorTab(selector, true, false);
                                  });
                                }
                              } else {
                                if (mounted) {
                                  showAlertDialog(
                                    context: context,
                                    title: AppLocalizations.of(context)!.unresolved,
                                    text: AppLocalizations.of(context)!.someInformationNeedsToBeFilled,
                                  );
                                }
                              }
                            })
                          },
                          icon: Icon(
                            Icons.arrow_right,
                            color: megaobraIconColor(),
                            size: 40,
                          ),
                          color: megaobraButtonBackground(),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (selector == 1)
                    SizedBox(
                      width: 600,
                      height: 433,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bubble_chart,
                                color: megaobraIconColor(),
                                size: 90,
                              ),
                              const SizedBox(width: 30),
                              MegaObraDefaultText(
                                text: "${_multipleMaterials.length} ${AppLocalizations.of(context)!.selectedPlural}.",
                                size: 48,
                              ),
                            ],
                          ),
                          MegaObraButton(
                            width: 500,
                            height: 40,
                            text: AppLocalizations.of(context)!.selectMaterials,
                            padding: const EdgeInsets.all(15.0),
                            function: () => {
                              if (mounted)
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MaterialSelectionPage(
                                        selectedMaterialIds: _multipleMaterials,
                                        selectedAmounts: _multipleMaterialsAmounts,
                                        onApply: (materials, amounts) => {
                                          if (mounted)
                                            {
                                              setState(() {
                                                _multipleMaterials = materials;
                                                _multipleMaterialsAmounts = amounts;
                                              }),
                                            }
                                        },
                                      ),
                                    ),
                                  ),
                                },
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (selector == 2)
                    SizedBox(
                      width: 600,
                      height: 433,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: megaobraIconColor(),
                                size: 90,
                              ),
                              const SizedBox(width: 30),
                              MegaObraDefaultText(
                                text: "${_multipleEmployees.length} ${AppLocalizations.of(context)!.selectedPlural}.",
                                size: 48,
                              ),
                            ],
                          ),
                          MegaObraButton(
                            width: 500,
                            height: 40,
                            text: AppLocalizations.of(context)!.selectEmployees,
                            padding: const EdgeInsets.all(15.0),
                            function: () => {
                              if (mounted)
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserSelectionPage(
                                        selectedUserIds: _multipleEmployees,
                                        onApply: (values) => {
                                          if (mounted)
                                            {
                                              setState(() {
                                                _multipleEmployees = values;
                                              }),
                                            }
                                        },
                                      ),
                                    ),
                                  ),
                                },
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 630,
                            child: SizedBox(
                              height: 60,
                              child: MegaObraFieldNumerical(
                                controller: _averageLabCostController,
                                label: AppLocalizations.of(context)!.averageLaborCostInReais,
                                maxLength: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (selector == 3)
                    SizedBox(
                      width: 600,
                      height: widget.referenceActivity == null ? 433 : 400,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.block,
                                color: megaobraIconColor(),
                                size: 90,
                              ),
                              const SizedBox(width: 30),
                              MegaObraDefaultText(
                                text: "${_multipleActivities.length} ${AppLocalizations.of(context)!.selectedPlural}.",
                                size: 48,
                              ),
                            ],
                          ),
                          MegaObraButton(
                            width: 500,
                            height: 40,
                            text: AppLocalizations.of(context)!.selectRestrictions,
                            padding: const EdgeInsets.all(15.0),
                            function: () => {
                              if (mounted)
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivitySelectionPage(
                                        selectedActivityIds: _multipleActivities,
                                        filterByProject: widget.filterRestrictionsByProjectId,
                                        onApply: (values) => {
                                          if (mounted)
                                            {
                                              setState(() {
                                                _multipleActivities = values;
                                              }),
                                            }
                                        },
                                      ),
                                    ),
                                  ),
                                },
                            },
                          ),
                        ],
                      ),
                    )
                  else if (selector == 0)
                    Column(
                      children: [
                        if (widget.referenceActivity != null)
                          Column(
                            children: [
                              SizedBox(height: 10),
                              MegaObraTinyText(
                                text: AppLocalizations.of(context)!.restrictionsMustBeManuallySelected,
                              ),
                            ],
                          ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 630,
                          child: SizedBox(
                            height: 60,
                            child: MegaObraFieldName(
                              controller: _descController,
                              label: AppLocalizations.of(context)!.description,
                              maxLength: 256,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 315,
                              child: SizedBox(
                                height: 58,
                                child: MegaObraFieldNumerical(
                                  controller: _proAmountController,
                                  label: AppLocalizations.of(context)!.professionalAmount,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox(
                              width: 315,
                              child: SizedBox(
                                height: 58,
                                child: MegaObraFieldNumerical(
                                  controller: _labAmountController,
                                  label: AppLocalizations.of(context)!.labourerAmount,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 315,
                              child: SizedBox(
                                height: 58,
                                child: MegaObraFieldNumerical(
                                  controller: _proTimeController,
                                  label: AppLocalizations.of(context)!.minutesForEachProfessional,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox(
                              width: 315,
                              child: SizedBox(
                                height: 58,
                                child: MegaObraFieldNumerical(
                                  controller: _labTimeController,
                                  label: AppLocalizations.of(context)!.minutesForEachLabourer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 310,
                              height: 60,
                              child: MegaObraDatePicker(
                                onDateSelected: _handleStartDateSelector,
                                label: widget.referenceActivity == null
                                    ? _persistentStartDate == null
                                        ? AppLocalizations.of(context)!.startDate
                                        : "${AppLocalizations.of(context)!.start}: ${formatDateTime(dateTime: _persistentStartDate)}"
                                    : "${AppLocalizations.of(context)!.original}: ${formatDateTime(
                                        dateTime: widget.referenceActivity!.start_date,
                                      )}",
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 310,
                              height: 60,
                              child: MegaObraDatePicker(
                                onDateSelected: _handleDeadlineSelector,
                                label: widget.referenceActivity == null
                                    ? _persistentDeadlineDate == null
                                        ? AppLocalizations.of(context)!.deadlineDate
                                        : "${AppLocalizations.of(context)!.deadline}: ${formatDateTime(dateTime: _persistentDeadlineDate)}"
                                    : "${AppLocalizations.of(context)!.original}: ${formatDateTime(
                                        dateTime: widget.referenceActivity!.deadline_date,
                                      )}",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (widget.referenceActivity == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 65,
                                width: 545,
                                child: _showDeprecatedLocations
                                    ? SizedBox(
                                        child: MegaObraLocationDropdown(
                                          onLocationSelected: _onLocationSelected,
                                          label: _selectedLocation == null
                                              ? AppLocalizations.of(context)!.selectLocationFirst
                                              : "${AppLocalizations.of(context)!.selectedLocation}: ${formatStringByLength(_selectedLocation!.enterprise, 20)}",
                                          showDeprecated: _showDeprecatedLocations,
                                        ),
                                      )
                                    : MegaObraLocationDropdown(
                                        onLocationSelected: _onLocationSelected,
                                        label: _selectedLocation == null
                                            ? AppLocalizations.of(context)!.selectLocationFirst
                                            : "${AppLocalizations.of(context)!.selectedLocation}: ${formatStringByLength(_selectedLocation!.enterprise, 20)}",
                                        showDeprecated: _showDeprecatedLocations,
                                      ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                children: [
                                  MegaObraSwitch(
                                    value: _showDeprecatedLocations,
                                    onChanged: (value) => {
                                      if (mounted)
                                        {
                                          setState(
                                            () {
                                              _selectedLocation = null;
                                              _multipleChunks = [];
                                              _showDeprecatedLocations = value;
                                            },
                                          ),
                                        },
                                    },
                                  ),
                                  MegaObraTinyText(
                                      text: "${AppLocalizations.of(context)!.show}\n${AppLocalizations.of(context)!.deprecated}")
                                ],
                              ),
                            ],
                          )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  MegaObraDefaultText(
                                    text: AppLocalizations.of(context)!.associateWithSameProjects,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MegaObraSwitch(
                                        value: _sameProject,
                                        onChanged: (value) => {
                                          if (mounted)
                                            {
                                              setState(() {
                                                _sameProject = value;
                                              }),
                                            }
                                        },
                                      ),
                                      const SizedBox(width: 15),
                                      MegaObraDefaultText(
                                        text: _sameProject ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        if (widget.referenceActivity == null)
                          MegaObraButton(
                            width: 635,
                            height: 40,
                            icon: _multipleChunks.isNotEmpty ? Icons.border_all : Icons.border_clear,
                            text: _multipleChunks.isNotEmpty
                                ? "${AppLocalizations.of(context)!.selectChunks} (${_multipleChunks.length} ${AppLocalizations.of(context)!.previouslySelected})"
                                : "${AppLocalizations.of(context)!.selectChunks} (${AppLocalizations.of(context)!.noneSelected}) (${AppLocalizations.of(context)!.optional})",
                            padding: const EdgeInsets.all(10.0),
                            function: () {
                              _selectedLocation == null
                                  ? mounted
                                      ? showAlertDialog(
                                          context: context,
                                          title: AppLocalizations.of(context)!.noReference,
                                          text: AppLocalizations.of(context)!.selectLocationFirst,
                                        )
                                      : null
                                  : mounted
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ActivityChunkSelector(
                                              location_id: _selectedLocation?.id ?? 0,
                                              preSelectedIds: _multipleChunks,
                                              onApply: (values) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        _multipleChunks = values;
                                                      },
                                                    ),
                                                  },
                                              },
                                            ),
                                          ),
                                        )
                                      : null;
                            },
                          ),
                        Visibility(
                          visible: widget.filterRestrictionsByProjectId != null,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const MegaObraDefaultText(
                                    text: 'Poderá ser executado em caso de chuva?',
                                    size: 20,
                                  ),
                                  const SizedBox(width: 25),
                                  MegaObraSwitch(
                                    value: rain,
                                    onChanged: (value) => {
                                      setState(() {
                                        rain = value;
                                      }),
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Opacity(
              opacity: selector == 3 ? 1.0 : 0.5,
              child: MegaObraButton(
                width: 300,
                height: 50,
                text: widget.referenceActivity == null
                    ? AppLocalizations.of(context)!.createActivity
                    : AppLocalizations.of(context)!.cloneActivity,
                padding: const EdgeInsets.all(0.0),
                function: () {
                  selector == 3 && fieldsAreOk()
                      ? widget.referenceActivity == null
                          ? mounted
                              ? tryToCreateNewActivity(
                                  context,
                                  generateActivityCreate(),
                                )
                              : null
                          : mounted
                              ? tryToCreateCloneActivity(
                                  context,
                                  generateActivityClone(),
                                )
                              : null
                      : mounted
                          ? showAlertDialog(
                              context: context,
                              title: AppLocalizations.of(context)!.unresolved,
                              text: AppLocalizations.of(context)!.fillEverythingFirst,
                            )
                          : null;
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
