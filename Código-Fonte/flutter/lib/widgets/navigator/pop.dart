import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MegaObraNavigatorPopButton extends StatefulWidget {
  const MegaObraNavigatorPopButton({super.key});

  @override
  State<MegaObraNavigatorPopButton> createState() => _MegaObraNavigatorPopButtonState();
}

class _MegaObraNavigatorPopButtonState extends State<MegaObraNavigatorPopButton> {
  String _label = "X";

  @override
  void initState() {
    super.initState();
    _loadLabel();
  }

  Future<void> _loadLabel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _label = prefs.getString("popLabel") ?? "X";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
      child: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "  $_label  ",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
