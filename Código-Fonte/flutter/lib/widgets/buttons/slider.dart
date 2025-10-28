import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraSliderConfirmWidget extends StatefulWidget {
  final String question;
  final VoidCallback onConfirm;

  // Adicionei parâmetros para personalizar as cores
  final Color backgroundColor = megaobraBackgroundColors()[0];
  final Color shadowColor = megaobraIconColor();
  final Color textColor = megaobraNeutralText();
  final Color sliderActiveColor = megaobraAlertText();
  final Color sliderInactiveColor = megaobraSwitchBackground();

  MegaObraSliderConfirmWidget({
    required this.question,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  _MegaObraSliderConfirmWidgetState createState() => _MegaObraSliderConfirmWidgetState();
}

class _MegaObraSliderConfirmWidgetState extends State<MegaObraSliderConfirmWidget> {
  double _sliderValue = 0.0;

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onSliderConfirm() {
    widget.onConfirm();
    setState(() {
      _sliderValue = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 650, // Dimensão menor para o pop-up
        padding: const EdgeInsets.all(12.0), // Ajuste no espaçamento interno
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MegaObraDefaultText(text: widget.question),
            const SizedBox(height: 12),
            Slider(
              value: _sliderValue,
              min: 0.0,
              max: 1.0,
              activeColor: widget.sliderActiveColor,
              inactiveColor: widget.sliderInactiveColor,
              onChanged: _onSliderChanged,
              onChangeEnd: (value) {
                if (value == 1.0) {
                  _onSliderConfirm();
                }
              },
            ),
            MegaObraTinyText(text: AppLocalizations.of(context)!.swipeToContinueRememberThisActionIsIrreversible),
            MegaObraTinyText(text: AppLocalizations.of(context)!.pressEscToExitOrClickOutsideThePopup)
          ],
        ),
      ),
    );
  }
}
