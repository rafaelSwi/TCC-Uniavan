import 'package:MegaObra/screens/manager/view/material.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraSimpleMaterialListWidget extends StatefulWidget {
  final String label;
  final List<model.Material> materials;
  final List<double>? amount;
  bool ableToNavigate;
  MegaObraSimpleMaterialListWidget({
    super.key,
    required this.label,
    required this.ableToNavigate,
    required this.materials,
    this.amount,
  });

  @override
  MegaObraSimpleMaterialListWidgetState createState() => MegaObraSimpleMaterialListWidgetState();
}

class MegaObraSimpleMaterialListWidgetState extends State<MegaObraSimpleMaterialListWidget> {
  @override
  void initState() {
    super.initState();
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
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: megaobraNeutralText(),
                ),
              ),
            ],
          ),
          Divider(
            color: megaobraListDivider(),
            thickness: 2.0,
          ),
          Expanded(
            child: widget.materials.isEmpty
                ? Center(
                    child: Text(
                    AppLocalizations.of(context)!.empty,
                    style: TextStyle(
                      color: megaobraNeutralText(),
                    ),
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
                            if (widget.amount != null)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    formatStringByLength("(${widget.amount![index]}) ${material.name}", 17),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: megaobraNeutralText(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            if (widget.amount == null)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    formatStringByLength(material.name, 17),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: megaobraNeutralText(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            Opacity(
                              opacity: widget.ableToNavigate ? 1.0 : 0.3,
                              child: IconButton(
                                onPressed: () => {
                                  if (widget.ableToNavigate)
                                    {
                                      viewMaterialsNavigator(material),
                                    }
                                },
                                icon: Icon(
                                  Icons.image_search_rounded,
                                  color: megaobraIconColor(),
                                  size: 20,
                                ),
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
