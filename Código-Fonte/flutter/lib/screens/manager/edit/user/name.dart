import 'package:MegaObra/utils/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/user.dart';

class EditUserNameScreen extends StatefulWidget {
  final User user;
  const EditUserNameScreen({super.key, required this.user});

  @override
  State<EditUserNameScreen> createState() => _EditUserNameScreenState();
}

class _EditUserNameScreenState extends State<EditUserNameScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: null);
    _nameController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void updateUserName(BuildContext context, TextEditingController name, int user_id) {
    try {
      if (name.text.toString().length < 6 || name.text.contains("  ")) {
        return;
      }
      String capitalized_name = formattedName(name.text);
      if (capitalized_name.toLowerCase() == widget.user.name.toLowerCase()) {
        return;
      }
      final Map<String, dynamic> updateData = {
        'name': capitalized_name,
      };
      if (mounted) {
        updateUserProperty(context, user_id, updateData);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.nameUpdate,
          text: AppLocalizations.of(context)!.requestToUpdateName,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to update a user Name: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingName,
        );
      }
    }
  }

  String formattedName(String name) {
    try {
      return name.trim().split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    } catch (e) {
      return "";
    }
  }

  String belowMessage(String formatted_name) {
    String stock_return_message = AppLocalizations.of(context)!.nameWillHaveItsInitialsInCapitalLetters;
    try {
      if (formatted_name.isEmpty) {
        return stock_return_message;
      }
      String message = "${AppLocalizations.of(context)!.theNameWillBeRecognizedAs} \" ${formattedName(_nameController.text)} \".";
      if (message.length > 100) {
        return stock_return_message;
      }
      return message;
    } catch (e) {
      return stock_return_message;
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
                  Icons.person,
                  color: megaobraIconColor(),
                  size: 80,
                ),
                const SizedBox(width: 25),
                MegaObraDefaultText(
                  text: widget.user.name,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 40),
            MegaObraTinyText(
              text: AppLocalizations.of(context)!.nameChangesTakesTime,
            ),
            const SizedBox(height: 5),
            MegaObraTinyText(
              text: belowMessage(
                formattedName(_nameController.text),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: MegaObraFieldName(controller: _nameController),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: _nameController.text.length < 3 ? 0.5 : 1.0,
              child: MegaObraButton(
                width: 300,
                height: 50,
                text: AppLocalizations.of(context)!.updateName,
                padding: const EdgeInsets.all(30.0),
                function: () => {
                  if (_nameController.text.length > 3 && mounted)
                    {
                      updateUserName(context, _nameController, widget.user.id),
                    }
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
