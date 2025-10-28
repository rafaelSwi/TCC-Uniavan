import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/crud/user.dart';

class EditUserPasswordScreen extends StatefulWidget {
  final User user;
  const EditUserPasswordScreen({super.key, required this.user});

  @override
  State<EditUserPasswordScreen> createState() => _EditUserPasswordScreenState();
}

class _EditUserPasswordScreenState extends State<EditUserPasswordScreen> {
  late TextEditingController _pswController;
  final minLengthPassword = 8;

  @override
  void initState() {
    super.initState();
    _pswController = TextEditingController(text: null);
  }

  @override
  void dispose() {
    _pswController.dispose();
    super.dispose();
  }

  String passwordLengthWarning(BuildContext context) {
    return "${AppLocalizations.of(context)!.minCharactersAcceptedInPassword} ${minLengthPassword}.";
  }

  void updateUserPassword(BuildContext context, TextEditingController password, int user_id) {
    try {
      if (password.text.toString().length < minLengthPassword) {
        return;
      }
      final Map<String, dynamic> updateData = {
        'password_hash': password.text,
      };
      if (mounted) {
        updateUserProperty(context, user_id, updateData);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.passwordUpdate,
          text: AppLocalizations.of(context)!.requestToUpdatePassword,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to update a user password: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingPassword,
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
              text: AppLocalizations.of(context)!.passwordUpdatesDoNotRevokeActiveTokens,
            ),
            MegaObraTinyText(
              text: passwordLengthWarning(context),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: MegaObraFieldPassword(controller: _pswController),
            ),
            const SizedBox(height: 20),
            Center(
              child: MegaObraButton(
                width: 300,
                height: 50,
                text: AppLocalizations.of(context)!.updateUserPassword,
                padding: const EdgeInsets.all(30.0),
                function: () => {
                  if (mounted)
                    {
                      updateUserPassword(context, _pswController, widget.user.id),
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
