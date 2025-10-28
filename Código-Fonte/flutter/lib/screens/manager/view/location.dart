import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/screens/manager/view/chunk.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class AdministratorLocationViewer extends StatefulWidget {
  final Location location;

  const AdministratorLocationViewer({
    super.key,
    required this.location,
  });

  @override
  State<AdministratorLocationViewer> createState() => _AdministratorLocationViewerState();
}

class _AdministratorLocationViewerState extends State<AdministratorLocationViewer> {
  @override
  void dispose() {
    super.dispose();
  }

  String formatDeprecatedText(bool deprecated, BuildContext context) {
    return deprecated ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no;
  }

  void showConfirmationDialog(
    BuildContext context,
    int locationId,
    bool isDeprecated,
  ) {
    if (!mounted) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deprecate,
            style: TextStyle(
              color: megaobraNeutralText(),
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.deprecateThisLocation,
            style: TextStyle(
              color: megaobraNeutralText(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                  color: megaobraNeutralText(),
                ),
              ),
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: TextStyle(
                  color: megaobraNeutralText(),
                ),
              ),
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                  deprecateLocation(isDeprecated, locationId);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deprecateLocation(bool isDeprecated, int locationId) async {
    if (isDeprecated) {
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.invalidRequest,
          text: AppLocalizations.of(context)!.thisLocationIsAlreadyMarkedAsDiscarded,
        );
      }
      return;
    }
    try {
      if (mounted) {
        bool? response = await markLocationAsDeprecated(context, locationId);
        if (response == true) {
          showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.location,
            text: AppLocalizations.of(context)!.requestToDeprecateLocationSent,
            pop: true,
          );
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorWhileDeprecateLocation,
        );
      }
    } catch (e) {
      print("Error while trying to deprecate location: $e");
      if (mounted) {
        showAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            text: AppLocalizations.of(context)!.errorWhileDeprecateLocation);
      }
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
              const MegaObraNavigatorPopButton(),
              const Spacer(),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    height: 120,
                    width: 800,
                    child: Row(
                      children: [
                        widget.location.deprecated
                            ? Icon(
                                color: megaobraIconColor(),
                                size: 60.0,
                                Icons.close,
                              )
                            : const Text(""),
                        Icon(
                          color: megaobraIconColor(),
                          size: 60.0,
                          Icons.location_on,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        MegaObraDefaultText(
                          text: formatCEP(widget.location.cep),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      bottom: 10.0,
                      left: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.enterprise,
                          sideText: formatStringByLength(
                            widget.location.enterprise,
                            50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.cep,
                          sideText: formatCEP(widget.location.cep),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MegaObraInformationContainer(
                          text: AppLocalizations.of(context)!.description,
                          sideText: formatStringByLength(
                            widget.location.description,
                            65,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: widget.location.deprecated
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MegaObraInformationContainer(
                                text: AppLocalizations.of(context)!.deprecated,
                                containerHeight: 35,
                                sideText: formatDeprecatedText(
                                  widget.location.deprecated,
                                  context,
                                ),
                              ),
                            ],
                          )
                        : const Text(""),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: MegaObraButton(
                      icon: Icons.border_bottom,
                      width: 430,
                      height: 35,
                      text: AppLocalizations.of(context)!.chunks,
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        bottom: 5.0,
                        right: 30.0,
                      ),
                      function: () => {
                        if (mounted)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdministratorChunkViewer(
                                  location_id: widget.location.id,
                                  title: widget.location.enterprise,
                                ),
                              ),
                            ),
                          },
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: MegaObraButton(
                      icon: widget.location.deprecated ? Icons.sentiment_dissatisfied : Icons.delete,
                      width: 430,
                      height: 35,
                      text: widget.location.deprecated
                          ? AppLocalizations.of(context)!.thisLocationIsAlreadyMarkedAsDiscarded
                          : AppLocalizations.of(context)!.deprecateLocation,
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        bottom: 10.0,
                        right: 30.0,
                      ),
                      function: () => {
                        if (mounted)
                          {
                            showConfirmationDialog(
                              context,
                              widget.location.id,
                              widget.location.deprecated,
                            ),
                          }
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
