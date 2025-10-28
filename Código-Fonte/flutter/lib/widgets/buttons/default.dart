import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MegaObraButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final EdgeInsetsGeometry padding;
  final void Function()? function;
  final IconData? icon;

  const MegaObraButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.padding,
    required this.function,
    this.icon,
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
        return Container(
          padding: padding,
          child: SizedBox(
            width: (scale >= 1.0) ? width * scale : width,
            height: (scale >= 1.0) ? height * scale : height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: megaobraButtonBackground(),
                foregroundColor: megaobraColoredText(),
              ),
              onPressed: function,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) Icon(icon),
                  SizedBox(
                    width: icon != null ? 8.0 : 0.0,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16 * scale),
                  ),
                  if (icon != null) const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
