import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/create/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/list/detailed/user.dart';
import 'package:MegaObra/widgets/navigator/refresh.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class FullUserViewer extends StatefulWidget {
  const FullUserViewer({
    super.key,
  });

  @override
  State<FullUserViewer> createState() => _FullUserViewerState();
}

class _FullUserViewerState extends State<FullUserViewer> {
  late Future<List<User>> futureUsers;
  bool ableToNavigateToUserByCpf = true;

  @override
  void initState() {
    super.initState();
    futureUsers = collectUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<User>> collectUsers() async {
    List<User>? users = await getAllUsers(context);
    return users ?? [];
  }

  void viewUserNavigator(String userCpf) async {
    if (!mounted) {
      return;
    }
    setState(() {
      ableToNavigateToUserByCpf = false;
    });
    User? collectedUser = await getUserByCpf(context, userCpf);
    try {
      if (collectedUser != null) {
        if (mounted) {
          setState(() {
            ableToNavigateToUserByCpf = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdministratorUserViewer(
                user: collectedUser!,
                spectate: false,
              ),
            ),
          );
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorOpeningUserMaybeCpfIsWrong,
        );
      }
    } catch (e) {
      print("e: ${e}");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorOpeningUser,
        );
      }
    }
    if (mounted) {
      setState(() {
        ableToNavigateToUserByCpf = true;
      });
    }
  }

  void searchUsingCpf(BuildContext context) {
    final TextEditingController cpf_controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: MegaObraDefaultText(text: AppLocalizations.of(context)!.insertCpf),
          content: MegaObraFieldCpf(controller: cpf_controller),
          backgroundColor: megaobraBackgroundColors()[0],
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: MegaObraTinyText(text: AppLocalizations.of(context)!.cancel),
            ),
            Opacity(
              opacity: ableToNavigateToUserByCpf ? 1.0 : 0.5,
              child: TextButton(
                onPressed: () {
                  if (cpf_controller.text.length != 14 || !ableToNavigateToUserByCpf) {
                    return;
                  }
                  viewUserNavigator(
                    cpf_controller.text.replaceAll(".", "").replaceAll("-", ""),
                  );
                  Navigator.of(context).pop();
                },
                child: MegaObraTinyText(text: AppLocalizations.of(context)!.search),
              ),
            ),
          ],
        );
      },
    );
  }

  void refreshUsers() {
    if (mounted) {
      setState(() {
        futureUsers = collectUsers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const MegaObraNavigatorPopButton(),
                  MegaObraRefreshButton(onPressed: refreshUsers),
                  const Spacer(),
                  Opacity(
                    opacity: (ableToNavigateToUserByCpf && [1, 2].contains(getLoggedUser()?.permission_id)) ? 1.0 : 0.5,
                    child: Container(
                      padding: const EdgeInsets.only(right: 30, top: 30, bottom: 15),
                      width: 340,
                      height: 100,
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: megaobraButtonBackground(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => {
                              if (mounted && ableToNavigateToUserByCpf)
                                {
                                  searchUsingCpf(context),
                                }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fingerprint,
                                  color: megaobraColoredText(),
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.searchByCpf,
                                  style: TextStyle(
                                    color: megaobraColoredText(),
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30.0),
                height: 600,
                width: 800,
                child: FutureBuilder<List<User>>(
                  future: futureUsers,
                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return MegaObraDetailedUserListWidget(
                        label: AppLocalizations.of(context)!.users,
                        users: snapshot.data!,
                        addButtonFunction: () => {
                          if (mounted)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateUserScreen(),
                                ),
                              ),
                            },
                        },
                      );
                    } else {
                      return Text(
                        AppLocalizations.of(context)!.noUsersFound,
                        style: TextStyle(
                          color: megaobraNeutralText(),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
