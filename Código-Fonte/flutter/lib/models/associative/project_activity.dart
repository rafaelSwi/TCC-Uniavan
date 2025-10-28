import 'package:MegaObra/utils/json_serializable.dart';

class ProjectActivityBase implements JsonSerializable {
  final int project_id;
  final int activity_id;

  const ProjectActivityBase({
    required this.project_id,
    required this.activity_id,
  });

  factory ProjectActivityBase.fromJson(Map<String, dynamic> json) {
    return ProjectActivityBase(
      project_id: json['project_id'] as int,
      activity_id: json['activity_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'project_id': project_id,
      'activity_id': activity_id,
    };
  }
}

class ProjectActivity extends ProjectActivityBase {
  final int id;
  final bool deprecated;

  const ProjectActivity({
    required this.id,
    required this.deprecated,
    required super.project_id,
    required super.activity_id,
  });

  factory ProjectActivity.fromJson(Map<String, dynamic> json) {
    return ProjectActivity(
      id: json['id'] as int,
      project_id: json['project_id'] as int,
      activity_id: json['activity_id'] as int,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': project_id,
      'activity_id': activity_id,
      'deprecated': deprecated,
    };
  }
}
