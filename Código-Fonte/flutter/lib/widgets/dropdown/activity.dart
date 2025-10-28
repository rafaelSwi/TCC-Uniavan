import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class MegaObraActivityDropdown extends StatefulWidget {
  final Function(Activity) onActivitySelected;
  final String label;
  const MegaObraActivityDropdown({
    super.key,
    required this.onActivitySelected,
    this.label = "",
  });

  @override
  State<MegaObraActivityDropdown> createState() => _MegaObraActivityDropdownState();
}

class _MegaObraActivityDropdownState extends State<MegaObraActivityDropdown> {
  Future<List<Activity>>? _activityItems;
  Activity? _selectedActivity;

  @override
  void initState() {
    super.initState();
    _activityItems = getAssociatedActivities(context, true);
  }

  String displayActivity(Activity activity) {
    int size = 50;
    String text = "${activity.description}";
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
      child: FutureBuilder<List<Activity>>(
        future: _activityItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              AppLocalizations.of(context)!.errorLoadingUsers,
              style: TextStyle(color: megaobraAlertText()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Activity> locations = snapshot.data!;

            return DropdownButtonHideUnderline(
              child: DropdownButton<Activity>(
                value: _selectedActivity,
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
                items: locations.map((Activity activity) {
                  return DropdownMenuItem<Activity>(
                    value: activity,
                    child: Row(
                      children: [
                        Icon(
                          Icons.construction,
                          color: megaobraColoredText(),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          displayActivity(activity),
                          style: TextStyle(
                            color: megaobraColoredText(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Activity? newValue) {
                  if (mounted) {
                    setState(() {
                      _selectedActivity = newValue;
                      widget.onActivitySelected(_selectedActivity!);
                    });
                  }
                },
              ),
            );
          } else {
            return Text(
              AppLocalizations.of(context)!.noActivitiesFound,
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
