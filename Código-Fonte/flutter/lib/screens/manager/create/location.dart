import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class CreateLocationScreen extends StatefulWidget {
  const CreateLocationScreen({super.key});

  @override
  State<CreateLocationScreen> createState() => _CreateLocationScreenState();
}

class _CreateLocationScreenState extends State<CreateLocationScreen> {
  final double megaobraInfoMaxWidth = 220.0;
  late TextEditingController _descController;
  late TextEditingController _enterpriseController;
  late TextEditingController _cepController;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: null,
    );
    _enterpriseController = TextEditingController(
      text: null,
    );
    _cepController = TextEditingController(
      text: null,
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _enterpriseController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  bool fieldsAreOk() {
    List<String> checks = [
      _descController.text,
      _enterpriseController.text,
      _cepController.text,
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

  LocationBase generateLocationCreate() {
    return LocationBase(
      enterprise: _enterpriseController.text,
      cep: _cepController.text.replaceAll("-", ""),
      description: _descController.text,
      deprecated: false,
    );
  }

  void tryToCreateNewLocation(
    BuildContext context,
    LocationBase newLocation,
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
        await createNewLocation(context, newLocation);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.location,
          text: AppLocalizations.of(context)!.requestToCreateLocationSent,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to create a location: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileCreatingLocation,
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
                  Icons.construction,
                  color: megaobraIconColor(),
                  size: 70,
                ),
                const SizedBox(width: 18),
                MegaObraDefaultText(
                  text: AppLocalizations.of(context)!.createLocation,
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
                  controller: _enterpriseController,
                  label: AppLocalizations.of(context)!.enterprise,
                  allowNumbers: true,
                  maxLength: 64,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 58,
              width: 630,
              child: MegaObraFieldCep(
                controller: _cepController,
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
            MegaObraButton(
              width: 300,
              height: 50,
              text: AppLocalizations.of(context)!.createLocation,
              padding: const EdgeInsets.all(5.0),
              function: () {
                if (mounted) {
                  tryToCreateNewLocation(
                    context,
                    generateLocationCreate(),
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
