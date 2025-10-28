import 'package:MegaObra/crud/schedule.dart';
import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/screens/manager/create/schedule.dart';
import 'package:MegaObra/widgets/list/detailed/schedule.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class FullScheduleViewer extends StatefulWidget {
  const FullScheduleViewer({
    super.key,
  });

  @override
  State<FullScheduleViewer> createState() => _FullScheduleViewerState();
}

class _FullScheduleViewerState extends State<FullScheduleViewer> {
  late Future<List<ScheduleCompact>> futureSchedules;

  @override
  void initState() {
    super.initState();
    futureSchedules = collectSchedules();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<ScheduleCompact>> collectSchedules() async {
    List<ScheduleCompact>? schedules = await getAllCompactSchedules(context);
    return schedules ?? [];
  }

  void refreshSchedules() {
    if (mounted) {
      setState(() {
        futureSchedules = collectSchedules();
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
                  MegaObraRefreshButton(onPressed: refreshSchedules),
                ],
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30.0),
                height: 600,
                width: 800,
                child: FutureBuilder<List<ScheduleCompact>>(
                  future: futureSchedules,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return MegaObraDetailedScheduleListWidget(
                        label: AppLocalizations.of(context)!.schedules,
                        schedules: snapshot.data!,
                        addButtonFunction: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateScheduleScreen(),
                                ),
                              ),
                            },
                        },
                      );
                    } else {
                      return Text(
                        AppLocalizations.of(context)!.noSchedulesFound,
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
