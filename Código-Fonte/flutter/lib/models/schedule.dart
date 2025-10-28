import 'package:MegaObra/utils/time_of_day.dart';
import 'package:MegaObra/utils/json_serializable.dart';

class ScheduleCreate implements JsonSerializable {
  final String schedule_name;
  final MegaObraTimeOfDay clock_in;
  final MegaObraTimeOfDay? break_in;
  final MegaObraTimeOfDay? break_out;
  final MegaObraTimeOfDay clock_out;

  const ScheduleCreate({
    required this.schedule_name,
    required this.clock_in,
    this.break_in,
    this.break_out,
    required this.clock_out,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'schedule_name': schedule_name,
      'clock_in': clock_in.toString(),
      'break_in': break_in?.toString(),
      'break_out': break_out?.toString(),
      'clock_out': clock_out.toString(),
    };
  }

  factory ScheduleCreate.fromJson(Map<String, dynamic> json) {
    return ScheduleCreate(
      schedule_name: json['schedule_name'],
      clock_in: _parseTimeOfDay(json['clock_in']),
      break_in: json['break_in'] != null ? _parseTimeOfDay(json['break_in']) : null,
      break_out: json['break_out'] != null ? _parseTimeOfDay(json['break_out']) : null,
      clock_out: _parseTimeOfDay(json['clock_out']),
    );
  }
}

class ScheduleBase implements JsonSerializable {
  final String schedule_name;
  final MegaObraTimeOfDay clock_in;
  final MegaObraTimeOfDay? break_in;
  final MegaObraTimeOfDay? break_out;
  final MegaObraTimeOfDay clock_out;
  final bool deprecated;

  const ScheduleBase({
    required this.schedule_name,
    required this.clock_in,
    this.break_in,
    this.break_out,
    required this.clock_out,
    required this.deprecated,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'schedule_name': schedule_name,
      'clock_in': clock_in.toJson(),
      'break_in': break_in?.toJson(),
      'break_out': break_out?.toJson(),
      'clock_out': clock_out.toJson(),
      'deprecated': deprecated,
    };
  }

  factory ScheduleBase.fromJson(Map<String, dynamic> json) {
    return ScheduleBase(
      schedule_name: json['schedule_name'],
      clock_in: _parseTimeOfDay(json['clock_in']),
      break_in: json['break_in'] != null ? _parseTimeOfDay(json['break_in']) : null,
      break_out: json['break_out'] != null ? _parseTimeOfDay(json['break_out']) : null,
      clock_out: _parseTimeOfDay(json['clock_out']),
      deprecated: json['deprecated'],
    );
  }
}

class Schedule extends ScheduleBase {
  final int id;

  const Schedule({
    required this.id,
    required super.schedule_name,
    required super.clock_in,
    required super.clock_out,
    super.break_in,
    super.break_out,
    required super.deprecated,
  });

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      'id': id,
      ...baseJson,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      schedule_name: json['schedule_name'],
      clock_in: _parseTimeOfDay(json['clock_in']),
      break_in: json['break_in'] != null ? _parseTimeOfDay(json['break_in']) : null,
      break_out: json['break_out'] != null ? _parseTimeOfDay(json['break_out']) : null,
      clock_out: _parseTimeOfDay(json['clock_out']),
      deprecated: json['deprecated'],
    );
  }
}

MegaObraTimeOfDay _parseTimeOfDay(dynamic time) {
  if (time is String) {
    final parts = time.split(':');
    return MegaObraTimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
      second: int.parse(parts[2]),
    );
  } else if (time is Map<String, dynamic>) {
    return MegaObraTimeOfDay.fromJson(time);
  } else {
    throw Exception('Invalid time format');
  }
}

class ScheduleCompact implements JsonSerializable {
  final int id;
  final String schedule_name;
  final MegaObraTimeOfDay clock_in;
  final MegaObraTimeOfDay? break_in;
  final MegaObraTimeOfDay? break_out;
  final MegaObraTimeOfDay clock_out;
  final int user_amount;

  const ScheduleCompact({
    required this.id,
    required this.schedule_name,
    required this.clock_in,
    this.break_in,
    this.break_out,
    required this.clock_out,
    required this.user_amount,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_name': schedule_name,
      'clock_in': clock_in.toJson(),
      'break_in': break_in?.toJson(),
      'break_out': break_out?.toJson(),
      'clock_out': clock_out.toJson(),
      'user_amount': user_amount,
    };
  }

  factory ScheduleCompact.fromJson(Map<String, dynamic> json) {
    return ScheduleCompact(
      id: json['id'],
      schedule_name: json['schedule_name'],
      clock_in: _parseTimeOfDay(json['clock_in']),
      break_in: json['break_in'] != null ? _parseTimeOfDay(json['break_in']) : null,
      break_out: json['break_out'] != null ? _parseTimeOfDay(json['break_out']) : null,
      clock_out: _parseTimeOfDay(json['clock_out']),
      user_amount: json['user_amount'],
    );
  }
}
