import 'package:MegaObra/models/token.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/app_settings/server.dart';
import 'package:MegaObra/screens/manager/main/main.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'dart:async';
import 'package:MegaObra/crud/auth.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/connectity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:flutter/services.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  static Stream<bool> createCheckStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 4));
      yield DateTime.now().second % 2 == 0;
    }
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int? _hoveredIndex = 0;
  bool loginButtonActive = true;
  Color backgroundExampleColor1 = megaobraBackgroundColors()[0];
  Color backgroundExampleColor2 = megaobraBackgroundColors()[1];
  Color listDividerExampleColor = megaobraListDivider();
  Color neutralTextExampleColor = megaobraNeutralText();
  var cpfController = TextEditingController(text: null);
  var pswController = TextEditingController(text: null);
  final checkStream = LoginPage.createCheckStream().asBroadcastStream();
  bool rememberCpf = false;
  String storedCpf = "";
  final FocusNode cpfFocusNode = FocusNode();
  final FocusNode pswFocusNode = FocusNode();

  @override
  void dispose() {
    cpfController.dispose();
    pswController.dispose();
    cpfFocusNode.dispose();
    pswFocusNode.dispose();
    checkStream.drain();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getRememberCpfBool(applyToTextfield: true);
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    String? app_theme = await getSharedAppTheme();

    if (app_theme != null) {
      if (app_theme == "laranja") {
        updateAppTheme(context, 0);
      } else if (app_theme == "verde") {
        updateAppTheme(context, 1);
      } else if (app_theme == "metal") {
        updateAppTheme(context, 2);
      } else if (app_theme == "oceano") {
        updateAppTheme(context, 3);
      } else if (app_theme == "canela") {
        updateAppTheme(context, 4);
      }
    }
  }

  void setSharedAppTheme(String theme_name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme_name);
    setState(() {
      getSharedAppTheme();
    });
  }

  void getAccessTokenAndLogin(
    BuildContext context,
    TextEditingController cpf,
    TextEditingController psw,
  ) async {
    if (mounted) {
      setState(() {
        loginButtonActive = false;
      });
    }
    bool hasConnection = await hasConnectionWithServer();
    if (!hasConnection && mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.connectivityError,
        text: AppLocalizations.of(context)!.couldNotEstablishServerConnection,
      );
      setState(() {
        loginButtonActive = true;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    try {
      String clean_cpf = cpf.text.replaceAll(".", "").replaceAll("-", "");
      TokenWithUser? TOKEN_WITH_USER = await getAccessToken(
        context,
        clean_cpf,
        psw.text,
      );
      if (TOKEN_WITH_USER != null) {
        setBearerToken(TOKEN_WITH_USER.access_token);
        setLoggedUser(TOKEN_WITH_USER.user);
        User? loggedUser = getLoggedUser();
        if (loggedUser != null) {
          if ([1, 2, 3].contains(loggedUser.permission_id)) {
            if (mounted) {
              if (rememberCpf) {
                setStoredCpf(cpfController.text);
              }
              setState(() {
                cpfController = TextEditingController(text: null);
                pswController = TextEditingController(text: null);
              });
              loginButtonActive = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainAdministratorPage(),
                  fullscreenDialog: true,
                ),
              );
            }
          } else if (mounted) {
            showAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.permissionError,
              text: AppLocalizations.of(context)!.permissionErrorDesc,
            );
            setState(() {
              loginButtonActive = true;
            });
          }
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.someLoginError,
        );
        setState(() {
          loginButtonActive = true;
        });
      }
    } catch (e) {
      print("Error while trying to Login: ${e}");
      if (mounted) {
        setState(() {
          loginButtonActive = true;
        });
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.connectionEstablishedButLoginFailed,
        );
      }
    }
    if (mounted) {
      setState(() {
        loginButtonActive = true;
      });
    }
  }

  String getIconTheme(int selection) {
    switch (selection) {
      case 0:
        return "lib/assets/icons/themes/worker.png";
      case 1:
        return "lib/assets/icons/themes/florest.png";
      case 2:
        return "lib/assets/icons/themes/rock.png";
      case 3:
        return "lib/assets/icons/themes/wave.png";
      case 4:
        return "lib/assets/icons/themes/moon.png";
      default:
        return "lib/assets/icons/themes/worker.png";
    }
  }

  void getRememberCpfBool({required bool applyToTextfield}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? remember_cpf = prefs.getBool("rememberCpf");
    setState(() {
      if (remember_cpf != null) {
        rememberCpf = remember_cpf;
        if (rememberCpf) {
          getStoredCpf();
        }
      }
    });
  }

  void getStoredCpf() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stored_cpf = prefs.getString("cpf");
    setState(() {
      if (stored_cpf != null) {
        storedCpf = stored_cpf;
        cpfController = TextEditingController(text: storedCpf);
      }
    });
  }

  void setRememberCpf({required bool newValue}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberCpf', newValue);
    setState(() {
      rememberCpf = newValue;
    });
    if (!rememberCpf) {
      setStoredCpf("");
    }
  }

  void setStoredCpf(String cpf) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cpf', cpf);
    setState(() {
      storedCpf = cpf;
    });
  }

  Color getThemeColor(int selection) {
    switch (selection) {
      case 0:
        return Colors.orange[700]!;
      case 1:
        return Colors.green;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  void updateAppTheme(BuildContext context, int index) {
    if (!mounted) {
      return;
    }
    if (index == 0) {
      setState(() {
        setSharedAppTheme("laranja");
        backgroundExampleColor1 = Colors.amber;
        backgroundExampleColor2 = Colors.orange;
        listDividerExampleColor = Colors.black;
        neutralTextExampleColor = Colors.black;
        applyMegaObraTheme(
          appThemeTitle: "laranja",
          backgroundColor1: Colors.amber,
          backgroundColor2: Colors.orange,
          backgroundGradientStart: Alignment.topCenter,
          backgroundGradientEnd: Alignment.bottomCenter,
          coloredText: Colors.amber,
          neutralText: Colors.black,
          neutralOpaqueText: Colors.black26,
          buttonBackground: Colors.black,
          listBackgroundColor1: Colors.white12,
          listBackgroundColor2: Colors.white10,
          listGradientStart: Alignment.topCenter,
          listGradientEnd: Alignment.bottomCenter,
          listDivider: Colors.black,
          switchBackground: Colors.orange,
          datePickerPrimary: Colors.amber,
          datePickerText: Colors.white,
          chunkTitle: Colors.blue,
          chunkBox: Colors.grey[800]!,
          alertText: Colors.pink,
          iconColor: Colors.black,
          navigatorBackground: Colors.amberAccent,
          snackBarText: Colors.white,
          snackBarBackground: Colors.red,
        );
      });
    }
    if (index == 2) {
      setState(() {
        setSharedAppTheme("metal");
        backgroundExampleColor1 = Colors.white;
        backgroundExampleColor2 = Colors.grey;
        listDividerExampleColor = Colors.black;
        neutralTextExampleColor = Colors.black;
        applyMegaObraTheme(
          appThemeTitle: "metal",
          backgroundColor1: backgroundExampleColor1,
          backgroundColor2: backgroundExampleColor2,
          backgroundGradientStart: Alignment.topCenter,
          backgroundGradientEnd: Alignment.bottomCenter,
          coloredText: Colors.black,
          neutralText: neutralTextExampleColor,
          neutralOpaqueText: Colors.black26,
          buttonBackground: Colors.grey,
          listBackgroundColor1: Colors.white30,
          listBackgroundColor2: Colors.white60,
          listGradientStart: Alignment.topCenter,
          listGradientEnd: Alignment.bottomCenter,
          listDivider: listDividerExampleColor,
          switchBackground: Colors.grey[600]!,
          datePickerPrimary: Colors.blueGrey,
          datePickerText: Colors.white,
          chunkTitle: Colors.blue,
          chunkBox: Colors.grey[800]!,
          alertText: Colors.red,
          iconColor: Colors.black,
          navigatorBackground: Colors.grey,
          snackBarText: Colors.white,
          snackBarBackground: Colors.pink,
        );
      });
    }
    if (index == 3) {
      setState(() {
        setSharedAppTheme("oceano");
        backgroundExampleColor1 = Colors.blue[600]!;
        backgroundExampleColor2 = Colors.blue[800]!;
        listDividerExampleColor = Colors.white;
        neutralTextExampleColor = Colors.white;
        applyMegaObraTheme(
          appThemeTitle: "oceano",
          backgroundColor1: backgroundExampleColor1,
          backgroundColor2: backgroundExampleColor2,
          backgroundGradientStart: Alignment.topCenter,
          backgroundGradientEnd: Alignment.bottomCenter,
          coloredText: const Color.fromARGB(255, 40, 120, 255),
          neutralText: neutralTextExampleColor,
          neutralOpaqueText: Colors.white70,
          buttonBackground: Colors.blue[100]!,
          listBackgroundColor1: Colors.blue[500]!,
          listBackgroundColor2: Colors.blue[600]!,
          listGradientStart: Alignment.topCenter,
          listGradientEnd: Alignment.bottomCenter,
          listDivider: listDividerExampleColor,
          switchBackground: Colors.blue[200]!,
          datePickerPrimary: Colors.blue[800],
          datePickerText: Colors.white,
          chunkTitle: Colors.white,
          chunkBox: Colors.grey[800]!,
          alertText: const Color.fromARGB(255, 255, 160, 190),
          iconColor: Colors.white,
          navigatorBackground: Colors.blue[400]!,
          snackBarText: Colors.white,
          snackBarBackground: Colors.blue[900]!,
        );
      });
    }
    if (index == 1) {
      setState(() {
        setSharedAppTheme("verde");
        backgroundExampleColor1 = Colors.green[200]!;
        backgroundExampleColor2 = Colors.green[200]!;
        listDividerExampleColor = Colors.black;
        neutralTextExampleColor = Colors.black;
        applyMegaObraTheme(
          appThemeTitle: "verde",
          backgroundColor1: backgroundExampleColor1,
          backgroundColor2: backgroundExampleColor2,
          backgroundGradientStart: Alignment.topCenter,
          backgroundGradientEnd: Alignment.bottomCenter,
          coloredText: Colors.greenAccent,
          neutralText: neutralTextExampleColor,
          neutralOpaqueText: Colors.black26,
          buttonBackground: Colors.green[800]!,
          listBackgroundColor1: Colors.green[300]!,
          listBackgroundColor2: Colors.green[500],
          listGradientStart: Alignment.topCenter,
          listGradientEnd: Alignment.bottomCenter,
          listDivider: listDividerExampleColor,
          switchBackground: Colors.green,
          datePickerPrimary: Colors.green,
          datePickerText: Colors.white,
          chunkTitle: Colors.blue,
          chunkBox: Colors.grey[800]!,
          alertText: Colors.red,
          iconColor: Colors.black,
          navigatorBackground: Colors.green[400]!,
          snackBarText: Colors.white,
          snackBarBackground: Colors.green[900]!,
        );
      });
    }
    if (index == 4) {
      setState(() {
        setSharedAppTheme("canela");
        backgroundExampleColor1 = Colors.black;
        backgroundExampleColor2 = Colors.grey[900]!;
        listDividerExampleColor = Colors.white;
        neutralTextExampleColor = Colors.white;
        applyMegaObraTheme(
          appThemeTitle: "canela",
          backgroundColor1: backgroundExampleColor1,
          backgroundColor2: backgroundExampleColor2,
          backgroundGradientStart: Alignment.topCenter,
          backgroundGradientEnd: Alignment.bottomCenter,
          coloredText: Colors.white,
          neutralText: neutralTextExampleColor,
          neutralOpaqueText: Colors.white30,
          buttonBackground: const Color.fromARGB(255, 163, 54, 20),
          listBackgroundColor1: Colors.black45,
          listBackgroundColor2: Colors.black26,
          listGradientStart: Alignment.topCenter,
          listGradientEnd: Alignment.bottomCenter,
          listDivider: listDividerExampleColor,
          switchBackground: const Color.fromARGB(255, 68, 48, 41),
          datePickerPrimary: const Color.fromARGB(255, 163, 54, 20),
          datePickerText: Colors.white,
          chunkTitle: Colors.lightBlue,
          chunkBox: Colors.grey[600]!,
          alertText: Colors.red,
          iconColor: Colors.white,
          navigatorBackground: const Color.fromARGB(255, 163, 54, 20),
          snackBarText: Colors.white,
          snackBarBackground: const Color.fromARGB(255, 163, 54, 20),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // here
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundExampleColor1, backgroundExampleColor2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'lib/assets/images/generic_logo_transparent.png',
                  ),
                ),
                const SizedBox(height: 36.0),
                SizedBox(
                  width: 450,
                  child: Focus(
                    focusNode: cpfFocusNode,
                    onKey: (node, event) {
                      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                        loginButtonActive
                            ? getAccessTokenAndLogin(
                                context,
                                cpfController,
                                pswController,
                              )
                            : null;
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: MegaObraFieldCpf(
                      controller: cpfController,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450,
                  child: Focus(
                    focusNode: pswFocusNode,
                    onKey: (node, event) {
                      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                        loginButtonActive
                            ? getAccessTokenAndLogin(
                                context,
                                cpfController,
                                pswController,
                              )
                            : null;
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: MegaObraFieldPassword(
                      controller: pswController,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: rememberCpf,
                      onChanged: (newValue) {
                        setState(() {
                          setRememberCpf(newValue: newValue);
                        });
                      },
                      activeColor: megaobraIconColor(),
                      activeTrackColor: megaobraSwitchBackground(),
                      inactiveThumbColor: megaobraIconColor(),
                      inactiveTrackColor: megaobraSwitchBackground(),
                    ),
                    const SizedBox(width: 20),
                    MegaObraDefaultText(
                      text: AppLocalizations.of(context)!.rememberCpf,
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 28.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return MouseRegion(
                      onEnter: (_) => mounted
                          ? setState(
                              () {
                                _hoveredIndex = index;
                              },
                            )
                          : null,
                      child: GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _hoveredIndex = index;
                            });
                            updateAppTheme(
                              context,
                              index,
                            );
                          }
                        },
                        child: AnimatedScale(
                          scale: _hoveredIndex == index ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: getThemeColor(index),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _hoveredIndex == index ? 1.0 : 0.0,
                                child: Image.asset(
                                  getIconTheme(index),
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 25.0),
                Opacity(
                  opacity: loginButtonActive ? 1.0 : 0.5,
                  child: SizedBox(
                    width: 450,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: megaobraButtonBackground(),
                        foregroundColor: megaobraColoredText(),
                      ),
                      onPressed: () => loginButtonActive
                          ? getAccessTokenAndLogin(
                              context,
                              cpfController,
                              pswController,
                            )
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "[ ENTER ↵ ]",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: megaobraColoredText(),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.login,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: megaobraColoredText(),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450,
                  child: Text(
                    AppLocalizations.of(context)!.contactAdministratorToCreateAnAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: megaobraNeutralText(),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.connectivityWithTheServer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: megaobraNeutralText(),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MegaObraButton(
                      width: 130,
                      height: 40,
                      text: AppLocalizations.of(context)!.server,
                      icon: Icons.swap_vertical_circle_rounded,
                      padding: const EdgeInsets.all(15.0),
                      function: () => {
                        if (mounted)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ServerSettingsScreen(),
                              ),
                            ),
                          },
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            showAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.about,
              text: "${AppLocalizations.of(context)!.version}: BETA 0.0.1",
            );
          }
        },
        backgroundColor: megaobraButtonBackground(),
        foregroundColor: megaobraColoredText(),
        child: const Icon(Icons.info),
      ),
    );
  }
}
