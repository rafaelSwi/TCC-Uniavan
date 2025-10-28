import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/screens/manager/view/chunk.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class AdministratorMaterialViewer extends StatefulWidget {
  final model.Material material;

  const AdministratorMaterialViewer({
    super.key,
    required this.material,
  });

  @override
  State<AdministratorMaterialViewer> createState() => _AdministratorMaterialViewerState();
}

class _AdministratorMaterialViewerState extends State<AdministratorMaterialViewer> {
  @override
  void dispose() {
    super.dispose();
  }

  String formatDeprecatedText(bool deprecated, BuildContext context) {
    return deprecated ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no;
  }

  String boolToLabel({required bool value}) {
    return value ? AppLocalizations.of(context)!.inStock : AppLocalizations.of(context)!.outOfStock;
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
              const MegaObraNavigatorPopButton(),
              const Spacer(),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    height: 120,
                    width: 800,
                    child: Row(
                      children: [
                        Icon(
                          color: megaobraIconColor(),
                          size: 60.0,
                          Icons.bubble_chart,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        MegaObraDefaultText(
                          text: widget.material.name,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      bottom: 10.0,
                      left: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.description,
                          sideText: formatStringByLength(
                            widget.material.description ?? "",
                            50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.averagePrice,
                          sideText: "R\$ ${widget.material.averagePrice} (${widget.material.measure})",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.inStock,
                          sideText: boolToLabel(value: widget.material.inStock),
                        ),
                      ],
                    ),
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
