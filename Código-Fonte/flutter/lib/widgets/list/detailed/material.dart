import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/screens/manager/view/material.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraDetailedMaterialListWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<model.Material> materials;
  final void Function()? addButtonFunction;

  const MegaObraDetailedMaterialListWidget({
    super.key,
    required this.label,
    required this.materials,
    this.emptyLabel = "?",
    required this.addButtonFunction,
  });

  @override
  MegaObraDetailedMaterialListWidgetState createState() => MegaObraDetailedMaterialListWidgetState();
}

class MegaObraDetailedMaterialListWidgetState extends State<MegaObraDetailedMaterialListWidget> {
  bool alsoShowDeprecated = false;

  @override
  void initState() {
    super.initState();
  }

  void showPermissionErrorMessage(BuildContext context) {
    if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.permissionError,
        text: AppLocalizations.of(context)!.youCannotCreateNewMaterial,
      );
    }
  }

  void viewMaterialsNavigator(model.Material materal) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdministratorMaterialViewer(material: materal),
        ),
      );
    }
  }

  String boolToLabel({required bool value}) {
    return value ? AppLocalizations.of(context)!.inStock : AppLocalizations.of(context)!.outOfStock;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: megaobraListBackgroundColors(),
          begin: megaobraListBackgroundGradientdStart(),
          end: megaobraListBackgroundGradientdEnd(),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: [1, 2].contains(getLoggedUser()?.permission_id)
                    ? (mounted ? widget.addButtonFunction : null)
                    : () => showPermissionErrorMessage(context),
                icon: Icon(
                  Icons.add,
                  color: megaobraNeutralText(),
                ),
              ),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: megaobraNeutralText(),
                ),
              ),
              const Spacer(),
            ],
          ),
          Divider(
            color: megaobraListDivider(),
            thickness: 2.0,
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                child: Icon(
                  Icons.info_outline,
                  color: megaobraIconColor(),
                  size: 20,
                ),
              ),
              Container(
                width: 400,
                padding: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                child: Text(
                  "${AppLocalizations.of(context)!.name} / ${AppLocalizations.of(context)!.price} / ${AppLocalizations.of(context)!.inStock}",
                  style: TextStyle(
                    color: megaobraNeutralText(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: widget.materials.isEmpty
                ? Center(
                    child: Text(
                    widget.emptyLabel,
                    style: TextStyle(color: megaobraNeutralText()),
                  ))
                : ListView.builder(
                    itemCount: widget.materials.length,
                    itemBuilder: (context, index) {
                      final material = widget.materials[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: megaobraListDivider()),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.bubble_chart,
                                color: megaobraNeutralText(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text(
                                      material.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: megaobraNeutralText(),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Text(
                                      "R\$${material.averagePrice} (${material.measure})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: megaobraNeutralText(),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      boolToLabel(value: material.inStock),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: megaobraNeutralText(),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => {
                                if (mounted)
                                  {
                                    viewMaterialsNavigator(material),
                                  }
                              },
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: megaobraIconColor(),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
