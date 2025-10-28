import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';

class MegaObraSimpleEmployeeListWidget extends StatefulWidget {
  final String label;
  final List<User> employees;
  bool ableToNavigate;
  MegaObraSimpleEmployeeListWidget({
    super.key,
    required this.label,
    required this.ableToNavigate,
    required this.employees,
  });

  @override
  MegaObraSimpleEmployeeListWidgetState createState() => MegaObraSimpleEmployeeListWidgetState();
}

class MegaObraSimpleEmployeeListWidgetState extends State<MegaObraSimpleEmployeeListWidget> {
  @override
  void initState() {
    super.initState();
  }

  void viewUserNavigator(int user_id) async {
    if (!mounted) {
      return;
    }
    setState(() {
      widget.ableToNavigate = false;
    });
    User? collectedUser = await getUserById(context, user_id);
    try {
      setState(() {
        widget.ableToNavigate = true;
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
        widget.ableToNavigate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: megaobraNeutralText(),
                ),
              ),
            ],
          ),
          Divider(
            color: megaobraListDivider(),
            thickness: 2.0,
          ),
          Expanded(
            child: widget.employees.isEmpty
                ? Center(
                    child: Text(
                    AppLocalizations.of(context)!.empty,
                    style: TextStyle(
                      color: megaobraNeutralText(),
                    ),
                  ))
                : ListView.builder(
                    itemCount: widget.employees.length,
                    itemBuilder: (context, index) {
                      final employee = widget.employees[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: megaobraListDivider()),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  formatStringByLength(employee.name, 17),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: megaobraNeutralText(),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: widget.ableToNavigate ? 1.0 : 0.3,
                              child: IconButton(
                                onPressed: () => {
                                  if (widget.ableToNavigate)
                                    {
                                      viewUserNavigator(employee.id),
                                    }
                                },
                                icon: Icon(
                                  Icons.person_search,
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
    );
  }
}
