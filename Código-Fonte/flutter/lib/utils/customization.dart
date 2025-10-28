import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App Theme
String _appTheme = "";

Future<String?> getSharedAppTheme() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? theme_name = prefs.getString("theme");
  appTheme(set: theme_name);
  return theme_name;
}

String appTheme({String? set}) {
  if (set != null) {
    _appTheme = set;
  }
  return _appTheme;
}

// Background
List<Color> _defaultBackgroundColors = [Colors.amber, Colors.orange];
AlignmentGeometry _defaultBackgroundGradientdStart = Alignment.topCenter;
AlignmentGeometry _defaultBackgroundGradientdEnd = Alignment.bottomCenter;

// Texts
Color _defaultColoredText = Colors.amber;
Color _defaultNeutralText = Colors.black;
Color _defaultNeutralOpaqueText = Colors.black26;

// Buttons
Color _defaultButtonBackground = Colors.black;

// Lists
List<Color> _defaultListBackgroundColors = [Colors.white12, Colors.white10];
AlignmentGeometry _defaultListBackgroundGradientdStart = Alignment.topCenter;
AlignmentGeometry _defaultLBackgroundGradientdEnd = Alignment.bottomCenter;
Color _defaultListDivider = Colors.black;

// Switch
Color _defaultSwitchBackground = Colors.orange;

// Datepicker
Color _defaultDatepickerText = Colors.white;
Color _defaultDatepickerPrimary = Colors.amber;

// Chunks
Color _defaultChunkTitle = Colors.blueAccent;
Color _defaultChunkBox = Colors.grey[800]!;

// Others
Color _defaultAlertText = Colors.pink;
Color _defaultIconColor = Colors.black;

// Navigator
Color _defaultNavigatorBackground = Colors.amberAccent;

// Snack Bar
Color _defaultSnackBarText = Colors.white;
Color _defaultSnackBarBackground = Colors.red;

List<Color> megaobraBackgroundColors({Color? setColor1, Color? setColor2}) {
  if (setColor1 != null) {
    _defaultBackgroundColors[0] = setColor1;
  }
  if (setColor2 != null) {
    _defaultBackgroundColors[1] = setColor2;
  }
  return _defaultBackgroundColors;
}

AlignmentGeometry megaobraBackgroundGradientdStart({AlignmentGeometry? set}) {
  if (set != null) {
    _defaultBackgroundGradientdStart = set;
  }
  return _defaultBackgroundGradientdStart;
}

AlignmentGeometry megaobraBackgroundGradientdEnd({AlignmentGeometry? set}) {
  if (set != null) {
    _defaultBackgroundGradientdEnd = set;
  }
  return _defaultBackgroundGradientdEnd;
}

Color megaobraColoredText({Color? set}) {
  if (set != null) {
    _defaultColoredText = set;
  }
  return _defaultColoredText;
}

Color megaobraNeutralText({Color? set}) {
  if (set != null) {
    _defaultNeutralText = set;
  }
  return _defaultNeutralText;
}

Color megaobraNeutralOpaqueText({Color? set}) {
  if (set != null) {
    _defaultNeutralOpaqueText = set;
  }
  return _defaultNeutralOpaqueText;
}

Color megaobraButtonBackground({Color? set}) {
  if (set != null) {
    _defaultButtonBackground = set;
  }
  return _defaultButtonBackground;
}

List<Color> megaobraListBackgroundColors({Color? setColor1, Color? setColor2}) {
  if (setColor1 != null) {
    _defaultListBackgroundColors[0] = setColor1;
  }
  if (setColor2 != null) {
    _defaultListBackgroundColors[1] = setColor2;
  }
  return _defaultListBackgroundColors;
}

AlignmentGeometry megaobraListBackgroundGradientdStart({AlignmentGeometry? set}) {
  if (set != null) {
    _defaultListBackgroundGradientdStart = set;
  }
  return _defaultListBackgroundGradientdStart;
}

AlignmentGeometry megaobraListBackgroundGradientdEnd({AlignmentGeometry? set}) {
  if (set != null) {
    _defaultLBackgroundGradientdEnd = set;
  }
  return _defaultLBackgroundGradientdEnd;
}

Color megaobraAlertText({Color? set}) {
  if (set != null) {
    _defaultAlertText = set;
  }
  return _defaultAlertText;
}

Color megaobraIconColor({Color? set}) {
  if (set != null) {
    _defaultIconColor = set;
  }
  return _defaultIconColor;
}

Color megaobraNavigatorBackground({Color? set}) {
  if (set != null) {
    _defaultNavigatorBackground = set;
  }
  return _defaultNavigatorBackground;
}

Color megaobraListDivider({Color? set}) {
  if (set != null) {
    _defaultListDivider = set;
  }
  return _defaultListDivider;
}

Color megaobraSwitchBackground({Color? set}) {
  if (set != null) {
    _defaultSwitchBackground = set;
  }
  return _defaultSwitchBackground;
}

Color megaobraDatePickerText({Color? set}) {
  if (set != null) {
    _defaultDatepickerText = set;
  }
  return _defaultDatepickerText;
}

Color megaobraDatePickerPrimary({Color? set}) {
  if (set != null) {
    _defaultDatepickerPrimary = set;
  }
  return _defaultDatepickerPrimary;
}

Color megaobraChunkTitle({Color? set}) {
  if (set != null) {
    _defaultChunkTitle = set;
  }
  return _defaultChunkTitle;
}

Color megaobraChunkBox({Color? set}) {
  if (set != null) {
    _defaultChunkBox = set;
  }
  return _defaultChunkBox;
}

Color megaobraSnackBarText({Color? set}) {
  if (set != null) {
    _defaultSnackBarText = set;
  }
  return _defaultSnackBarText;
}

Color megaobraSnackBarBackground({Color? set}) {
  if (set != null) {
    _defaultSnackBarBackground = set;
  }
  return _defaultSnackBarBackground;
}

void applyMegaObraTheme({
  required String appThemeTitle,
  Color? backgroundColor1,
  Color? backgroundColor2,
  AlignmentGeometry? backgroundGradientStart,
  AlignmentGeometry? backgroundGradientEnd,
  Color? coloredText,
  Color? neutralText,
  Color? neutralOpaqueText,
  Color? buttonBackground,
  Color? listBackgroundColor1,
  Color? listBackgroundColor2,
  AlignmentGeometry? listGradientStart,
  AlignmentGeometry? listGradientEnd,
  Color? listDivider,
  Color? switchBackground,
  Color? datePickerPrimary,
  Color? datePickerText,
  Color? chunkTitle,
  Color? chunkBox,
  Color? alertText,
  Color? iconColor,
  Color? navigatorBackground,
  Color? snackBarText,
  Color? snackBarBackground,
}) {
  appTheme(set: appThemeTitle);
  megaobraBackgroundColors(
    setColor1: backgroundColor1,
    setColor2: backgroundColor2,
  );
  megaobraBackgroundGradientdStart(
    set: backgroundGradientStart,
  );
  megaobraBackgroundGradientdEnd(
    set: backgroundGradientEnd,
  );

  megaobraColoredText(
    set: coloredText,
  );
  megaobraNeutralText(
    set: neutralText,
  );
  megaobraNeutralOpaqueText(
    set: neutralOpaqueText,
  );

  megaobraButtonBackground(
    set: buttonBackground,
  );

  megaobraListBackgroundColors(
    setColor1: listBackgroundColor1,
    setColor2: listBackgroundColor2,
  );
  megaobraListBackgroundGradientdStart(
    set: listGradientStart,
  );
  megaobraListBackgroundGradientdEnd(
    set: listGradientEnd,
  );
  megaobraListDivider(
    set: listDivider,
  );
  megaobraSwitchBackground(
    set: switchBackground,
  );
  megaobraDatePickerPrimary(
    set: datePickerPrimary,
  );
  megaobraDatePickerText(
    set: datePickerText,
  );
  megaobraChunkTitle(
    set: chunkTitle,
  );
  megaobraChunkBox(
    set: chunkBox,
  );
  megaobraAlertText(
    set: alertText,
  );
  megaobraIconColor(
    set: iconColor,
  );

  megaobraNavigatorBackground(
    set: navigatorBackground,
  );

  megaobraSnackBarText(
    set: snackBarText,
  );
  megaobraSnackBarBackground(
    set: snackBarBackground,
  );
}
