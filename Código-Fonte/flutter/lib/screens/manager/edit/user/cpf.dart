import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/crud/user.dart';

class EditUserCpfScreen extends StatefulWidget {
  final User user;
  const EditUserCpfScreen({super.key, required this.user});

  @override
  State<EditUserCpfScreen> createState() => _EditUserCpfScreenState();
}

class _EditUserCpfScreenState extends State<EditUserCpfScreen> {
  late TextEditingController _cpfController;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController(text: null);
  }

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  void updateUserCpf(BuildContext context, TextEditingController cpf, int user_id) {
    try {
      String clean_cpf = cpf.text.replaceAll(".", "").replaceAll("-", "");
      if (clean_cpf.length != 11 || clean_cpf == widget.user.cpf) {
        return;
      }
      final Map<String, dynamic> updateData = {
        'cpf': clean_cpf,
      };
      if (mounted) {
        updateUserProperty(context, user_id, updateData);
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.cpfRegistrationUpdate,
          text: AppLocalizations.of(context)!.requestToUpdateCpf,
          pop: true,
        );
      }
    } catch (e) {
      print("Error while trying to update a user CPF: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileUpdatingCpf,
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
                  text: formatStringByLength(widget.user.name, 56),
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 40),
            MegaObraDefaultText(
              text: "${AppLocalizations.of(context)!.currentCpf}: ${formatCPF(widget.user.cpf)}",
              size: 30,
            ),
            const SizedBox(height: 20),
            MegaObraTinyText(
              text: AppLocalizations.of(context)!.cpfChangesTakesTime,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: MegaObraFieldCpf(controller: _cpfController),
            ),
            const SizedBox(height: 20),
            Center(
              child: MegaObraButton(
                width: 300,
                height: 50,
                text: AppLocalizations.of(context)!.updateCpf,
                padding: const EdgeInsets.all(30.0),
                function: () => {
                  if (mounted)
                    {
                      updateUserCpf(context, _cpfController, widget.user.id),
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
