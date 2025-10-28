import 'package:MegaObra/utils/customization.dart';
import 'package:flutter/material.dart';

class MegaObraSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const MegaObraSwitch({Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  _MegaObraSwitchState createState() => _MegaObraSwitchState();
}

class _MegaObraSwitchState extends State<MegaObraSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _thumbColorAnimation;
  late Animation<Color?> _trackColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _thumbColorAnimation = ColorTween(
      begin: megaobraColoredText(),
      end: megaobraSwitchBackground(),
    ).animate(_controller);

    _trackColorAnimation = ColorTween(
      begin: megaobraSwitchBackground(),
      end: megaobraAlertText(),
    ).animate(_controller);

    if (widget.value) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MegaObraSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
        if (widget.value) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 60.0,
            height: 30.0,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: _trackColorAnimation.value,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: widget.value ? 30.0 : 0.0,
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _thumbColorAnimation.value,
                      boxShadow: [
                        BoxShadow(
                          color: megaobraNeutralText(),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
