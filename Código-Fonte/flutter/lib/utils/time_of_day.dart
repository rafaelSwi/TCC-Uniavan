import 'package:flutter/material.dart';

class MegaObraTimeOfDay {
  final int hour; // 0 to 23
  final int minute; // 0 to 59
  final int second; // 0 to 59

  const MegaObraTimeOfDay({
    required this.hour,
    required this.minute,
    required this.second,
  })  : assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59),
        assert(second >= 0 && second <= 59);

  static TimeOfDay convertToTimeOfDay(MegaObraTimeOfDay? megaobraTime) {
    if (megaobraTime != null) {
      return TimeOfDay(
        hour: megaobraTime.hour,
        minute: megaobraTime.minute,
      );
    } else {
      return const TimeOfDay(
        hour: 0,
        minute: 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
      'second': second,
    };
  }

  factory MegaObraTimeOfDay.fromJson(Map<String, dynamic> json) {
    return MegaObraTimeOfDay(
      hour: json['hour'],
      minute: json['minute'],
      second: json['second'],
    );
  }

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}
