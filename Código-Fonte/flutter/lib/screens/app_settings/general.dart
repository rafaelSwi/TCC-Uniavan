import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class GeneralSettingsScreen extends StatefulWidget {
  final VoidCallback? onExit;

  const GeneralSettingsScreen({super.key, this.onExit});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  double? interfaceScale = 1.0;
  String? popLabel;
  String? selectedLanguage;
  bool teste_1 = false;
  @override
  void initState() {
    getTextScale();
    getPopButtonLabel();
    getSelectedLanguage();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onExit != null) {
      widget.onExit!();
    }
    super.dispose();
  }

  String getTranslatedAppTheme(BuildContext context) {
    if (appTheme() == "laranja") {
      return AppLocalizations.of(context)!.orangeTheme;
    } else if (appTheme() == "metal") {
      return AppLocalizations.of(context)!.grayTheme;
    } else if (appTheme() == "oceano") {
      return AppLocalizations.of(context)!.blueTheme;
    } else if (appTheme() == "verde") {
      return AppLocalizations.of(context)!.greenTheme;
    } else if (appTheme() == "canela") {
      return AppLocalizations.of(context)!.darkTheme;
    } else {
      return AppLocalizations.of(context)!.def;
    }
  }

  void setPopButtonLabel(String label) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('popLabel', label);
    setState(() {
      popLabel = label;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const GeneralSettingsScreen(),
      ),
    );
  }

  void getPopButtonLabel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? pop_label = prefs.getString("popLabel");
    setState(() {
      popLabel = pop_label;
    });
  }

  void getSelectedLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? selected_lang = prefs.getString("selectedLanguage");
    setState(() {
      selectedLanguage = selected_lang;
    });
  }

  void setSelectedLanguage(String langCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', langCode);
    setState(() {
      selectedLanguage = langCode;
    });
  }

  void setTextScale(double scale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('interfaceScale', scale);
    setState(() {
      interfaceScale = scale;
    });
  }

  void getTextScale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? text_scale = prefs.getDouble("interfaceScale");
    setState(() {
      interfaceScale = text_scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MegaObraNavigatorPopButton(),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 360,
                      child: Column(
                        children: [
                          MegaObraDefaultText(
                            text: AppLocalizations.of(context)!.language,
                          ),
                          MegaObraTinyText(
                            text: AppLocalizations.of(context)!.languageDesc,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: ((interfaceScale ?? 1.0) > 1.0) ? 860 : 750,
                      child: Row(
                        children: [
                          Opacity(
                            opacity: (selectedLanguage == 'pt') ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 240,
                              height: 40,
                              text: AppLocalizations.of(context)!.portuguese,
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setSelectedLanguage('pt'),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (selectedLanguage == 'en') ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 228,
                              height: 40,
                              text: AppLocalizations.of(context)!.english,
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setSelectedLanguage('en'),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (selectedLanguage == 'es') ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 228,
                              height: 40,
                              text: AppLocalizations.of(context)!.spanish,
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setSelectedLanguage('es'),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 360,
                      child: Column(
                        children: [
                          MegaObraDefaultText(
                            text: AppLocalizations.of(context)!.interfaceScale,
                          ),
                          MegaObraTinyText(
                            text: AppLocalizations.of(context)!.interfaceScaleDesc,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 750,
                      child: Row(
                        children: [
                          Opacity(
                            opacity: (interfaceScale == 0.8) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 90,
                              height: 40,
                              text: "0.8x",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setTextScale(0.8),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (interfaceScale == 0.9) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 90,
                              height: 40,
                              text: "0.9x",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setTextScale(0.9),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (interfaceScale == 1.0) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 160,
                              height: 40,
                              text: "1.0x (${AppLocalizations.of(context)!.def})",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setTextScale(1.0),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (interfaceScale == 1.1) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 90,
                              height: 40,
                              text: "1.1x",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setTextScale(1.1),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (interfaceScale == 1.2) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 90,
                              height: 40,
                              text: "1.2x",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setTextScale(1.2),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 360,
                      child: Column(
                        children: [
                          MegaObraDefaultText(text: AppLocalizations.of(context)!.closeButtonLabel),
                          MegaObraTinyText(
                            text: AppLocalizations.of(context)!.closeButtonLabelDesc,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 750,
                      child: Row(
                        children: [
                          Opacity(
                            opacity: (popLabel == "X") ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 145,
                              height: 40,
                              text: "X (${AppLocalizations.of(context)!.def})",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setPopButtonLabel("X"),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (popLabel == AppLocalizations.of(context)!.back.toUpperCase()) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 145,
                              height: 40,
                              text: AppLocalizations.of(context)!.back.toUpperCase(),
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setPopButtonLabel(AppLocalizations.of(context)!.back.toUpperCase()),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (popLabel == AppLocalizations.of(context)!.goBack.toUpperCase()) ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 145,
                              height: 40,
                              text: AppLocalizations.of(context)!.goBack.toUpperCase(),
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setPopButtonLabel(AppLocalizations.of(context)!.goBack.toUpperCase()),
                              },
                            ),
                          ),
                          Opacity(
                            opacity: (popLabel == "   ") ? 1.0 : 0.4,
                            child: MegaObraButton(
                              width: 145,
                              height: 40,
                              text: "(${AppLocalizations.of(context)!.empty})",
                              padding: const EdgeInsets.all(6.0),
                              function: () => {
                                setPopButtonLabel("   "),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 360,
                      child: Column(
                        children: [
                          MegaObraDefaultText(
                            text: AppLocalizations.of(context)!.appearance,
                          ),
                          MegaObraTinyText(
                            text: AppLocalizations.of(context)!.appearanceDesc,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 750,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            color: megaobraIconColor(),
                            size: 31,
                          ),
                          const SizedBox(width: 20),
                          MegaObraDefaultText(
                            text: getTranslatedAppTheme(context).toUpperCase(),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
