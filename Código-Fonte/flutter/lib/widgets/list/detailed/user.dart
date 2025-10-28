import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MegaObraDetailedUserListWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<User> users;
  final bool showUndone;
  final void Function()? addButtonFunction;

  const MegaObraDetailedUserListWidget({
    super.key,
    required this.label,
    required this.users,
    this.emptyLabel = "?",
    this.showUndone = true,
    required this.addButtonFunction,
  });

  @override
  MegaObraDetailedUserListWidgetState createState() => MegaObraDetailedUserListWidgetState();
}

class MegaObraDetailedUserListWidgetState extends State<MegaObraDetailedUserListWidget> {
  bool hideRestrictedUsers = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool ableToNavigate = true;

  @override
  void initState() {
    super.initState();
  }

  void viewUserNavigator(int user_id) async {
    setState(() {
      ableToNavigate = false;
    });
    try {
      User? user = await getUserById(context, user_id);
      if (user != null) {
        if (mounted) {
          setState(() {
            ableToNavigate = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdministratorUserViewer(
                user: user,
                spectate: false,
              ),
            ),
          );
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorOpeningUser,
        );
      }
    } catch (e) {
      print("Error: ${e}");
    }
    if (mounted) {
      setState(() {
        ableToNavigate = true;
      });
    }
  }

  String getPermIcon(User user) {
    switch (user.permission_id) {
      case 1:
        return "lib/assets/icons/permission/adm.svg";
      case 2:
        return "lib/assets/icons/permission/man.svg";
      case 3:
        return "lib/assets/icons/permission/wor.svg";
      case 4:
        return "lib/assets/icons/permission/res.svg";
      default:
        return "lib/assets/icons/permission/man.svg";
    }
  }

  String getRoleDesc(User user) {
    switch (user.role_id) {
      case (1):
        var s = AppLocalizations.of(context)!.professional.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
      case (2):
        var s = AppLocalizations.of(context)!.labourer.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
      case (3):
        var s = AppLocalizations.of(context)!.assistant.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
      default:
        var s = AppLocalizations.of(context)!.undefined.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
    }
  }

  String getPermDesc(User user) {
    switch (user.permission_id) {
      case (1):
        var s = AppLocalizations.of(context)!.admin.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
      case (2):
        var s = AppLocalizations.of(context)!.manager.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
      case (3):
        var s = AppLocalizations.of(context)!.worker.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
      default:
        var s = AppLocalizations.of(context)!.restricted.toUpperCase();
        return s.length >= 3 ? s.substring(0, 3) : s;
    }
  }

  void applySearch() {
    if (mounted) {
      setState(() {
        searchQuery = searchController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<User> filteredUsers = widget.users
        .where((user) =>
            (hideRestrictedUsers ? user.permission_id != 4 : true) &&
            (searchQuery.isEmpty || user.name.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: megaobraListBackgroundColors(),
          begin: megaobraListBackgroundGradientdStart(),
          end: megaobraListBackgroundGradientdEnd(),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            applySearch();
          }
        },
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: megaobraNeutralOpaqueText(),
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchByName,
                          hintStyle: TextStyle(color: megaobraNeutralOpaqueText()),
                          filled: true,
                          fillColor: Colors.transparent,
                          icon: Icon(
                            Icons.person_search,
                            color: megaobraNeutralOpaqueText(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: applySearch,
                    icon: const Icon(Icons.search),
                    color: megaobraIconColor(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: mounted ? widget.addButtonFunction : null,
                  icon: Icon(
                    Icons.add,
                    color: megaobraNeutralText(),
                  ),
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: megaobraNeutralText(),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.hideRestrictedUsers,
                      style: TextStyle(color: megaobraNeutralText(), fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    MegaObraSwitch(
                      value: hideRestrictedUsers,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            hideRestrictedUsers = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: megaobraListDivider(),
              thickness: 2.0,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                  child: Icon(
                    Icons.info_outline,
                    color: megaobraIconColor(),
                    size: 20,
                  ),
                ),
                Container(
                  width: 400,
                  padding: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                  child: Text(
                    "${AppLocalizations.of(context)!.permission} / ${AppLocalizations.of(context)!.role} / ${AppLocalizations.of(context)!.name} / ${AppLocalizations.of(context)!.cpf}",
                    style: TextStyle(
                      color: megaobraNeutralText(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        widget.emptyLabel,
                        style: TextStyle(
                          color: megaobraNeutralText(),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: megaobraListDivider()),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SvgPicture.asset(
                                  getPermIcon(user),
                                  color: megaobraIconColor(),
                                  height: 20,
                                  width: 50,
                                ),
                              ),
                              Container(
                                width: 50,
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Text(
                                  getPermDesc(user),
                                  style: TextStyle(
                                    color: megaobraNeutralText(),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Text(
                                  getRoleDesc(user),
                                  style: TextStyle(
                                    color: megaobraNeutralText(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    formatStringByLength(
                                      user.name,
                                      46,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: megaobraNeutralText(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              MegaObraDefaultText(
                                text: formatCPF(user.cpf),
                                size: 20,
                              ),
                              Opacity(
                                opacity: ableToNavigate ? 1.0 : 0.5,
                                child: IconButton(
                                  onPressed: () => {
                                    if (mounted && ableToNavigate)
                                      {
                                        viewUserNavigator(user.id),
                                      }
                                  },
                                  icon: Icon(
                                    Icons.format_list_bulleted,
                                    color: megaobraIconColor(),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
