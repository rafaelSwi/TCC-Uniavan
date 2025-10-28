import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MegaObraDefaultText extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final bool opaque;

  const MegaObraDefaultText({
    super.key,
    required this.text,
    this.size = 33,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.w400,
    this.opaque = false,
  });

  Future<double> _getTextScale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('interfaceScale') ?? 1.0;
    } catch (e) {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _getTextScale(),
      builder: (context, snapshot) {
        final scale = snapshot.data ?? 1.0;
        return Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            color: opaque ? megaobraNeutralOpaqueText() : megaobraNeutralText(),
            fontFamily: 'Roboto',
            fontWeight: fontWeight,
            fontSize: size * scale,
          ),
        );
      },
    );
  }
}

class MegaObraTinyText extends StatelessWidget {
  final String text;

  const MegaObraTinyText({super.key, required this.text});

  Future<double> _getTextScale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('interfaceScale') ?? 1.0;
    } catch (e) {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _getTextScale(),
      builder: (context, snapshot) {
        final scale = snapshot.data ?? 1.0;
        return Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: megaobraNeutralText(),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 13 * scale,
          ),
        );
      },
    );
  }
}
