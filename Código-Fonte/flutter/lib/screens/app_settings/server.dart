import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/connectity.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/buttons/default.dart';

class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({super.key});

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  late TextEditingController _mainIpController;
  late TextEditingController _preIpController;
  late TextEditingController _portController;
  bool applyPort = true;
  bool https = false;

  final checkStream = createCheckStream().asBroadcastStream();

  static Stream<bool> createCheckStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 4));
      yield DateTime.now().second % 2 == 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _mainIpController = TextEditingController(
      text: null,
    );
    _preIpController = TextEditingController(
      text: null,
    );
    _portController = TextEditingController(
      text: null,
    );
  }

  @override
  void dispose() {
    _mainIpController.dispose();
    _preIpController.dispose();
    _portController.dispose();
    checkStream.drain();
    super.dispose();
  }

  void applyNewAddress() {
    var url = "";
    if (https) {
      url = "${url}https";
    } else {
      url = "${url}http";
    }
    url = "${url}${_preIpController.text}://${_mainIpController.text}";
    if (applyPort) {
      url = "${url}:${_portController.text}";
    }
    setBaseUrl(newUrl: url);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MegaObraNavigatorPopButton(),
            const Spacer(),
            Icon(
              Icons.swap_vertical_circle_rounded,
              color: megaobraIconColor(),
              size: 80,
            ),
            const SizedBox(
              height: 10,
            ),
            MegaObraDefaultText(text: "${AppLocalizations.of(context)!.currentHost}:\n${getBaseUrl()}"),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 270,
                  child: MegaObraFieldName(
                    label: AppLocalizations.of(context)!.ipAddress,
                    controller: _mainIpController,
                    allowNumbers: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: const MegaObraDefaultText(
                    text: ":",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: MegaObraFieldNumerical(
                    controller: _portController,
                    label: AppLocalizations.of(context)!.port,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MegaObraDefaultText(
                      text: AppLocalizations.of(context)!.httpSecure,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MegaObraSwitch(
                        value: https,
                        onChanged: (v) => {
                              if (mounted)
                                {
                                  setState(() {
                                    https = v;
                                  }),
                                }
                            }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MegaObraDefaultText(
                      text: AppLocalizations.of(context)!.applyPort,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MegaObraSwitch(
                        value: applyPort,
                        onChanged: (v) => {
                              if (mounted)
                                {
                                  setState(() {
                                    applyPort = v;
                                  }),
                                }
                            }),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MegaObraButton(
              width: 300,
              height: 50,
              text: AppLocalizations.of(context)!.applyNewHost,
              padding: const EdgeInsets.all(20.0),
              function: () => {
                setState(() {
                  if (mounted) {
                    applyNewAddress();
                  }
                }),
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MegaObraTinyText(text: AppLocalizations.of(context)!.connectivityWithTheServer),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: StreamBuilder<bool>(
                    stream: checkStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LinearProgressIndicator(
                          color: megaobraNeutralText(),
                          backgroundColor: Colors.transparent,
                        );
                      }
                      return FutureBuilder<bool>(
                        future: hasConnectionWithServer(),
                        builder: (context, connectionSnapshot) {
                          if (connectionSnapshot.connectionState == ConnectionState.waiting) {
                            return LinearProgressIndicator(
                              color: megaobraNeutralText(),
                              backgroundColor: Colors.transparent,
                            );
                          }
                          bool connect = connectionSnapshot.data ?? false;
                          return Icon(
                            connect ? Icons.lens : Icons.signal_cellular_connected_no_internet_0_bar,
                            color: connect ? Colors.green : megaobraAlertText(),
                            size: 20.0,
                          );
                        },
                      );
                    },
                  ),
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
