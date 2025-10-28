import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/screens/manager/view/location.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/switch/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraDetailedLocationListWidget extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final List<Location> locations;
  final bool showUndone;
  final void Function()? addButtonFunction;

  const MegaObraDetailedLocationListWidget({
    super.key,
    required this.label,
    required this.locations,
    this.emptyLabel = "?",
    this.showUndone = true,
    required this.addButtonFunction,
  });

  @override
  MegaObraDetailedLocationListWidgetState createState() => MegaObraDetailedLocationListWidgetState();
}

class MegaObraDetailedLocationListWidgetState extends State<MegaObraDetailedLocationListWidget> {
  bool alsoShowDeprecated = false;

  @override
  void initState() {
    super.initState();
  }

  void showPermissionErrorMessage(BuildContext context) {
    if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.permissionError,
        text: AppLocalizations.of(context)!.notPossibleToCreateLocation,
      );
    }
  }

  void viewLocationsNavigator(Location location) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdministratorLocationViewer(location: location),
        ),
      );
    }
  }

  IconData getLocationIcon(bool deprecated) {
    if (deprecated) {
      return Icons.close;
    } else {
      return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Location> filteredLocations =
        alsoShowDeprecated ? widget.locations : widget.locations.where((location) => !location.deprecated).toList();
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
              IconButton(
                onPressed: [1, 2].contains(getLoggedUser()?.permission_id)
                    ? (mounted ? widget.addButtonFunction : null)
                    : () => showPermissionErrorMessage(context),
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
                    AppLocalizations.of(context)!.showDeprecatedLocations,
                    style: TextStyle(color: megaobraNeutralText(), fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  MegaObraSwitch(
                    value: alsoShowDeprecated,
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          alsoShowDeprecated = value;
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
                  "${AppLocalizations.of(context)!.cep.toUpperCase()} / ${AppLocalizations.of(context)!.enterprise}",
                  style: TextStyle(
                    color: megaobraNeutralText(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: filteredLocations.isEmpty
                ? Center(
                    child: Text(
                    widget.emptyLabel,
                    style: TextStyle(color: megaobraNeutralText()),
                  ))
                : ListView.builder(
                    itemCount: filteredLocations.length,
                    itemBuilder: (context, index) {
                      final location = filteredLocations[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: megaobraListDivider()),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                getLocationIcon(location.deprecated),
                                color: megaobraNeutralText(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  formatCEP(location.cep),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: megaobraNeutralText(),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            MegaObraDefaultText(
                              text: formatStringByLength(location.enterprise, 45),
                              size: 20,
                            ),
                            IconButton(
                              onPressed: () => {
                                if (mounted)
                                  {
                                    viewLocationsNavigator(location),
                                  }
                              },
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: megaobraIconColor(),
                                size: 20,
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
