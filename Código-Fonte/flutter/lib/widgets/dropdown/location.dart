import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/location.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraLocationDropdown extends StatefulWidget {
  final Function(Location) onLocationSelected;
  final String label;
  final bool showDeprecated;
  const MegaObraLocationDropdown({
    super.key,
    required this.onLocationSelected,
    this.label = "",
    this.showDeprecated = false,
  });

  @override
  State<MegaObraLocationDropdown> createState() => _MegaObraLocationDropdownState();
}

class _MegaObraLocationDropdownState extends State<MegaObraLocationDropdown> {
  Future<List<Location>>? _locationItems;
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _locationItems = loadLocations();
  }

  Future<List<Location>> loadLocations() async {
    List<Location> allLocations = await getAllLocations(context);
    return filterLocations(allLocations);
  }

  Future<List<Location>> filterLocations(List<Location> locationList) async {
    if (widget.showDeprecated) {
      return locationList;
    } else {
      return locationList.where((location) => !location.deprecated).toList();
    }
  }

  String displayLocation(Location loc) {
    int size = 50;
    String text = "${formatCEP(loc.cep)} | ${loc.enterprise} | ${loc.description}";
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
        borderRadius: BorderRadius.circular(6),
      ),
      child: FutureBuilder<List<Location>>(
        future: _locationItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              AppLocalizations.of(context)!.errorLoadingLocations,
              style: TextStyle(color: megaobraAlertText()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Location> locations = snapshot.data!;

            return DropdownButtonHideUnderline(
              child: DropdownButton<Location>(
                value: _selectedLocation,
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
                items: locations.map((Location location) {
                  return DropdownMenuItem<Location>(
                    value: location,
                    child: Row(
                      children: [
                        Icon(
                          location.deprecated ? Icons.close : Icons.location_on,
                          color: megaobraColoredText(),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          displayLocation(location),
                          style: TextStyle(
                            color: megaobraColoredText(),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Location? newValue) {
                  if (mounted) {
                    setState(() {
                      _selectedLocation = newValue;
                      if (_selectedLocation != null) {
                        widget.onLocationSelected(_selectedLocation!);
                      }
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
