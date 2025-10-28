import 'package:MegaObra/crud/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/screens/manager/create/material.dart';
import 'package:MegaObra/widgets/list/detailed/material.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';

class FullMaterialViewer extends StatefulWidget {
  const FullMaterialViewer({
    super.key,
  });

  @override
  State<FullMaterialViewer> createState() => _FullMaterialViewerState();
}

class _FullMaterialViewerState extends State<FullMaterialViewer> {
  late Future<List<model.Material>> futureMaterials;

  @override
  void initState() {
    super.initState();
    futureMaterials = collectMaterials();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<model.Material>> collectMaterials() async {
    List<model.Material>? materials = await getAllMaterials(context);
    return materials ?? [];
  }

  void refreshLocations() {
    if (mounted) {
      setState(() {
        futureMaterials = collectMaterials();
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
                child: FutureBuilder<List<model.Material>>(
                  future: futureMaterials,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return MegaObraDetailedMaterialListWidget(
                        label: AppLocalizations.of(context)!.materials,
                        materials: snapshot.data!,
                        addButtonFunction: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateMaterialScreen(),
                                ),
                              ),
                            },
                        },
                      );
                    } else {
                      return Text(
                        AppLocalizations.of(context)!.noMaterialsFound,
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
