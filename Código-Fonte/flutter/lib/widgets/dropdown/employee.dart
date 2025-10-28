import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraEmployeeDropdown extends StatefulWidget {
  final Function(User) onUserSelected;
  final String label;
  const MegaObraEmployeeDropdown({
    super.key,
    required this.onUserSelected,
    this.label = "",
  });

  @override
  State<MegaObraEmployeeDropdown> createState() => _MegaObraEmployeeDropdownState();
}

class _MegaObraEmployeeDropdownState extends State<MegaObraEmployeeDropdown> {
  Future<List<User>>? _userItems;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _userItems = getAllUsers(context);
  }

  String displayUser(User user) {
    int size = 50;
    String text = "${formatCPF(user.cpf)} | ${user.name}";
    if (text.length > size) {
      return "${text.substring(0, size)}...";
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: megaobraButtonBackground(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FutureBuilder<List<User>>(
        future: _userItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              AppLocalizations.of(context)!.errorLoadingUsers,
              style: TextStyle(color: megaobraAlertText()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            List<User> locations = snapshot.data!;

            return DropdownButtonHideUnderline(
              child: DropdownButton<User>(
                value: _selectedUser,
                dropdownColor: megaobraButtonBackground(),
                hint: Text(
                  widget.label,
                  style: TextStyle(
                    color: megaobraColoredText(),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: megaobraColoredText(),
                  size: 50,
                ),
                style: TextStyle(
                  color: megaobraColoredText(),
                  fontSize: 18,
                ),
                items: locations.map((User user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: megaobraColoredText(),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          displayUser(user),
                          style: TextStyle(
                            color: megaobraColoredText(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (User? newValue) {
                  if (mounted) {
                    setState(() {
                      _selectedUser = newValue;
                      widget.onUserSelected(_selectedUser!);
                    });
                  }
                },
              ),
            );
          } else {
            return Text(
              AppLocalizations.of(context)!.noLocationsFound,
              style: TextStyle(
                color: megaobraAlertText(),
              ),
            );
          }
        },
      ),
    );
  }
}
