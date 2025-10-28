import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';

class UserSelectionPage extends StatefulWidget {
  final List<int> selectedUserIds;
  final Function(List<int>) onApply;

  const UserSelectionPage({
    Key? key,
    required this.selectedUserIds,
    required this.onApply,
  }) : super(key: key);

  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  List<User> _loadedUsers = [];
  List<User> _filteredUsers = [];
  Set<int> _markedUserIds = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _markedUserIds = widget.selectedUserIds.toSet();
    _loadUsers();
  }

  void _loadUsers() async {
    var resultUsers = await getAllUsers(context);
    if (mounted) {
      setState(() {
        _loadedUsers = resultUsers;
        _filteredUsers = resultUsers;
      });
    }
  }

  void _toggleUserSelection(int userId) {
    if (mounted) {
      setState(() {
        if (_markedUserIds.contains(userId)) {
          _markedUserIds.remove(userId);
        } else {
          _markedUserIds.add(userId);
        }
      });
    }
  }

  void _filterUsers(String query) {
    if (mounted) {
      setState(() {
        _searchQuery = query;
        _filteredUsers = _loadedUsers.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: megaobraNeutralText(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Icon(Icons.search, color: megaobraNeutralOpaqueText()),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: _filterUsers,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchByName,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: megaobraNeutralOpaqueText()),
                ),
                style: TextStyle(color: megaobraNeutralOpaqueText()),
              ),
            ),
          ],
        ),
        backgroundColor: megaobraSwitchBackground(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _filteredUsers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        final isMarked = _markedUserIds.contains(user.id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: GestureDetector(
                            onTap: () => _toggleUserSelection(user.id),
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                Checkbox(
                                  value: isMarked,
                                  onChanged: (value) {
                                    _toggleUserSelection(user.id);
                                  },
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MegaObraDefaultText(
                                        text: formatStringByLength(user.name, 68),
                                      ),
                                      MegaObraTinyText(
                                        text: formatCPF(user.cpf),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.person_search_sharp),
                                  color: megaobraIconColor(),
                                  onPressed: () => {
                                    if (mounted)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AdministratorUserViewer(
                                              user: user,
                                              spectate: true,
                                            ),
                                            fullscreenDialog: true,
                                          ),
                                        ),
                                      },
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MegaObraInformationContainer(
                text: AppLocalizations.of(context)!.selectedPlural,
                containerWidth: 270,
                maxWidth: 320,
                sideText: _markedUserIds.length.toString(),
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onApply(_markedUserIds.toList());
          Navigator.pop(context);
        },
        backgroundColor: megaobraButtonBackground(),
        foregroundColor: megaobraColoredText(),
        child: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        ),
      ),
    );
  }
}
