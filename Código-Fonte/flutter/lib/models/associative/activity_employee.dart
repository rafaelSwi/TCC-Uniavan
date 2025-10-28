import 'package:MegaObra/utils/json_serializable.dart';

class ActivityEmployeeBase implements JsonSerializable {
  final int activity_id;
  final int employee_id;

  const ActivityEmployeeBase({
    required this.activity_id,
    required this.employee_id,
  });

  factory ActivityEmployeeBase.fromJson(Map<String, dynamic> json) {
    return ActivityEmployeeBase(
      activity_id: json['activity_id'] as int,
      employee_id: json['employee_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'activity_id': activity_id,
      'employee_id': employee_id,
    };
  }
}

class ActivityEmployee extends ActivityEmployeeBase {
  final int id;
  final bool deprecated;

  const ActivityEmployee({
    required this.id,
    required this.deprecated,
    required super.activity_id,
    required super.employee_id,
  });

  factory ActivityEmployee.fromJson(Map<String, dynamic> json) {
    return ActivityEmployee(
      id: json['id'] as int,
      activity_id: json['activity_id'] as int,
      employee_id: json['employee_id'] as int,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_id': activity_id,
      'employee_id': employee_id,
      'deprecated': deprecated,
    };
  }
}
