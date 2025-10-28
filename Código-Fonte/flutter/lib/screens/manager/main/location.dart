import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/screens/manager/create/location.dart';
import 'package:MegaObra/widgets/list/detailed/location.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';

class FullLocationViewer extends StatefulWidget {
  const FullLocationViewer({
    super.key,
  });

  @override
  State<FullLocationViewer> createState() => _FullLocationViewerState();
}

class _FullLocationViewerState extends State<FullLocationViewer> {
  late Future<List<Location>> futureLocations;

  @override
  void initState() {
    super.initState();
    futureLocations = collectLocations();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Location>> collectLocations() async {
    List<Location>? locations = await getAllLocations(context);
    return locations ?? [];
  }

  void refreshLocations() {
    if (mounted) {
      setState(() {
        futureLocations = collectLocations();
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
                  MegaObraRefreshButton(onPressed: refreshLocations),
                ],
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30.0),
                height: 600,
                width: 800,
                child: FutureBuilder<List<Location>>(
                  future: futureLocations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return MegaObraDetailedLocationListWidget(
                        label: AppLocalizations.of(context)!.locations,
                        locations: snapshot.data!,
                        addButtonFunction: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateLocationScreen(),
                                ),
                              ),
                            },
                        },
                      );
                    } else {
                      return Text(
                        AppLocalizations.of(context)!.noLocationsFound,
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
