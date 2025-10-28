import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class MegaObraUserSelector extends StatefulWidget {
  final List<User> users;
  final String searchBarLabel;
  final void Function(List<User>) onUserSelected;

  const MegaObraUserSelector({
    super.key,
    required this.users,
    required this.onUserSelected,
    required this.searchBarLabel,
  });

  @override
  _MegaObraUserSelectorState createState() => _MegaObraUserSelectorState();
}

class _MegaObraUserSelectorState extends State<MegaObraUserSelector> {
  List<User> selectedUsers = [];
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
    searchController.addListener(_filterUsers);
    widget.onUserSelected(selectedUsers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void toggleSelection(User user) {
    if (mounted) {
      setState(() {
        if (selectedUsers.contains(user)) {
          selectedUsers.remove(user);
        } else {
          selectedUsers.add(user);
        }
        widget.onUserSelected(selectedUsers);
      });
    }
  }

  void viewUserNavigator(int user_id) async {
    if (!mounted) {
      return;
    }
    User? collected_user = await getUserById(context, user_id);
    if (collected_user != null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministratorUserViewer(
              user: collected_user,
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
  }

  void _filterUsers() {
    if (!mounted) {
      return;
    }
    setState(() {
      filteredUsers = widget.users
          .where((user) =>
              user.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
              formatCPF(user.cpf).contains(searchController.text))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: widget.searchBarLabel,
              labelStyle: TextStyle(color: megaobraNeutralText()),
              prefixIcon: const Icon(Icons.search),
              iconColor: megaobraIconColor(),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: megaobraNeutralText()),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: megaobraNeutralText()),
              ),
            ),
          ),
        ),
        // List of Users
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: megaobraNeutralText()),
            ),
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(
                        formatStringByLength(
                          "${formatCPF(user.cpf)} | ${user.name}",
                          42,
                        ),
                        style: TextStyle(
                          color: megaobraNeutralText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: selectedUsers.contains(user),
                      onChanged: (bool? selected) {
                        toggleSelection(user);
                      },
                      activeColor: megaobraNeutralText(),
                      checkColor: megaobraColoredText(),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Divider(
                      color: megaobraListDivider(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
