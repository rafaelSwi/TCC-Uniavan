import 'package:MegaObra/utils/customization.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraRefreshButton extends StatefulWidget {
  final Function onPressed; // A função a ser executada ao clicar no botão

  const MegaObraRefreshButton({super.key, required this.onPressed});

  @override
  State<MegaObraRefreshButton> createState() => _MegaObraRefreshButtonState();
}

class _MegaObraRefreshButtonState extends State<MegaObraRefreshButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 30, bottom: 15),
      width: 350,
      height: 100,
      child: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: megaobraButtonBackground(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => widget.onPressed(),
            child: Row(
              children: [
                Icon(
                  Icons.refresh,
                  color: megaobraColoredText(),
                  size: 30,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  AppLocalizations.of(context)!.refresh,
                  style: TextStyle(
                    color: megaobraColoredText(),
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
