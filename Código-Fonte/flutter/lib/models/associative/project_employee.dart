import 'package:MegaObra/utils/json_serializable.dart';

class ProjectEmployeeBase implements JsonSerializable {
  final int project_id;
  final int employee_id;

  const ProjectEmployeeBase({
    required this.project_id,
    required this.employee_id,
  });

  factory ProjectEmployeeBase.fromJson(Map<String, dynamic> json) {
    return ProjectEmployeeBase(
      project_id: json['project_id'] as int,
      employee_id: json['employee_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'project_id': project_id,
      'employee_id': employee_id,
    };
  }
}

class ProjectEmployee extends ProjectEmployeeBase {
  final int id;
  final bool deprecated;

  const ProjectEmployee({
    required this.id,
    required this.deprecated,
    required super.project_id,
    required super.employee_id,
  });

  factory ProjectEmployee.fromJson(Map<String, dynamic> json) {
    return ProjectEmployee(
      id: json['id'] as int,
      project_id: json['project_id'] as int,
      employee_id: json['employee_id'] as int,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': project_id,
      'employee_id': employee_id,
      'deprecated': deprecated,
    };
  }
}
