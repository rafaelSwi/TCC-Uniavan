import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/screens/manager/create/activity.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/widgets/list/detailed/activity.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/crud/activity.dart';

class FullActivityViewer extends StatefulWidget {
  const FullActivityViewer({
    super.key,
  });

  @override
  State<FullActivityViewer> createState() => _FullActivityViewerState();
}

class _FullActivityViewerState extends State<FullActivityViewer> {
  late Future<List<Activity>> futureActivities;

  @override
  void initState() {
    super.initState();
    futureActivities = collectActivities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Activity>> collectActivities() async {
    List<Activity>? activities = await getAssociatedActivities(context, [1, 2].contains(getLoggedUser()?.permission_id));
    return activities ?? [];
  }

  void refreshActivities() {
    if (mounted) {
      setState(() {
        futureActivities = collectActivities();
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
                  MegaObraRefreshButton(onPressed: refreshActivities),
                ],
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30.0),
                height: 600,
                width: 800,
                child: FutureBuilder<List<Activity>>(
                  future: futureActivities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return MegaObraDetailedActivityListWidget(
                        label: AppLocalizations.of(context)!.activities,
                        activities: snapshot.data!,
                        emptyLabel: AppLocalizations.of(context)!.noActivitiesFound,
                        addButtonFunction: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateActivityScreen(),
                                ),
                              ),
                            }
                        },
                      );
                    } else {
                      return Text(
                        AppLocalizations.of(context)!.noActivitiesFound,
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
