import 'package:flutter/material.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MegaObraInformationContainer extends StatefulWidget {
  final String text;
  final String? sideText;
  final double containerWidth;
  final double containerHeight;
  final double fontSize;
  final double maxWidth;

  const MegaObraInformationContainer({
    super.key,
    required this.text,
    this.sideText,
    this.containerWidth = 200,
    this.containerHeight = 50,
    this.fontSize = 18,
    this.maxWidth = 800,
  });

  @override
  State<MegaObraInformationContainer> createState() => _MegaObraInformationContainerState();
}

class _MegaObraInformationContainerState extends State<MegaObraInformationContainer> {
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadScale();
  }

  Future<void> _loadScale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _scale = prefs.getDouble('interfaceScale') ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final adjustedWidth = widget.containerWidth * _scale;
    final adjustedHeight = widget.containerHeight * _scale;
    final adjustedFontSize = widget.fontSize * _scale;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: megaobraButtonBackground(),
              borderRadius: BorderRadius.circular(5),
            ),
            width: adjustedWidth,
            height: adjustedHeight,
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: megaobraColoredText(),
                fontSize: adjustedFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (widget.sideText != null)
            Flexible(
              child: MegaObraDefaultText(
                text: widget.sideText!,
                size: adjustedFontSize,
              ),
            ),
        ],
      ),
    );
  }
}
