import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/crud/material.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/models/material.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class CreateMaterialScreen extends StatefulWidget {
  const CreateMaterialScreen({super.key});

  @override
  State<CreateMaterialScreen> createState() => _CreateMaterialScreenState();
}

class _CreateMaterialScreenState extends State<CreateMaterialScreen> {
  final double megaobraInfoMaxWidth = 220.0;
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _averagePriceController;
  late TextEditingController _measureController;
  bool inStock = true;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: null,
    );
    _nameController = TextEditingController(
      text: null,
    );
    _averagePriceController = TextEditingController(
      text: null,
    );
    _measureController = TextEditingController(
      text: null,
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _nameController.dispose();
    _averagePriceController.dispose();
    _measureController.dispose();
    super.dispose();
  }

  bool fieldsAreOk() {
    List<String> checks = [
      _nameController.text,
      _descController.text,
      _averagePriceController.text,
      _measureController.text,
    ];
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] == "") {
        return false;
      }
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

  double stringToDouble({required String content}) {
    try {
      return double.parse(content.replaceAll(",", "."));
    } catch (_) {
      return 0.0;
    }
  }

  MaterialBase generateMaterialCreate() {
    return MaterialBase(
        name: _nameController.text,
        description: _descController.text,
        averagePrice: stringToDouble(content: _averagePriceController.text),
        measure: _measureController.text,
        inStock: inStock);
  }

  void tryToCreateNewMaterial(
    BuildContext context,
    MaterialBase newMaterial,
  ) async {
    try {
      if (fieldsAreOk() == false) {
        if (mounted) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.emptyFields,
            text: AppLocalizations.of(context)!.someInformationNeedsToBeFilled,
          );
        }
        return;
      }
      if (mounted) {
        await createNewMaterial(context, newMaterial);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.material,
          text: AppLocalizations.of(context)!.requestToCreateMaterialSent,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to create a material: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCreatingMaterial,
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
                  Icons.bubble_chart,
                  color: megaobraIconColor(),
                  size: 70,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.createMaterial,
                  size: 40,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 630,
              child: SizedBox(
                height: 58,
                child: MegaObraFieldName(
                  controller: _nameController,
                  label: AppLocalizations.of(context)!.materialName,
                  allowNumbers: true,
                  maxLength: 32,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 630,
              child: SizedBox(
                height: 60,
                child: MegaObraFieldName(
                  controller: _descController,
                  label: AppLocalizations.of(context)!.description,
                  maxLength: 64,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 630,
              child: SizedBox(
                height: 60,
                child: MegaObraFieldNumerical(
                  controller: _averagePriceController,
                  label: AppLocalizations.of(context)!.averagePriceInReais,
                  maxLength: 64,
                  allowDecimal: true,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 630,
              child: SizedBox(
                height: 60,
                child: MegaObraFieldName(
                  controller: _measureController,
                  label: AppLocalizations.of(context)!.averagePriceReference,
                  maxLength: 32,
                  allowNumbers: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MegaObraDefaultText(text: AppLocalizations.of(context)!.inStock),
                SizedBox(width: 18),
                MegaObraSwitch(
                    value: inStock,
                    onChanged: (value) {
                      setState(() {
                        inStock = !inStock;
                      });
                    }),
              ],
            ),
            SizedBox(height: 30),
            MegaObraButton(
              width: 300,
              height: 50,
              text: AppLocalizations.of(context)!.createMaterial,
              padding: const EdgeInsets.all(5.0),
              function: () {
                if (mounted) {
                  tryToCreateNewMaterial(
                    context,
                    generateMaterialCreate(),
                  );
                }
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
