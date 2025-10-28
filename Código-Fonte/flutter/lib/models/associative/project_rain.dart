import 'package:MegaObra/utils/json_serializable.dart';

class ProjectRainBase implements JsonSerializable {
  final int project_id;
  final int rain_activity_id;

  const ProjectRainBase({
    required this.project_id,
    required this.rain_activity_id,
  });

  factory ProjectRainBase.fromJson(Map<String, dynamic> json) {
    return ProjectRainBase(
      project_id: json['project_id'] as int,
      rain_activity_id: json['rain_activity_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'project_id': project_id,
      'rain_activity_id': rain_activity_id,
    };
  }
}

class ProjectRain extends ProjectRainBase {
  final int id;
  final bool deprecated;

  const ProjectRain({
    required this.id,
    required this.deprecated,
    required super.project_id,
    required super.rain_activity_id,
  });

  factory ProjectRain.fromJson(Map<String, dynamic> json) {
    return ProjectRain(
      id: json['id'] as int,
      project_id: json['project_id'] as int,
      rain_activity_id: json['rain_activity_id'] as int,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': project_id,
      'rain_activity_id': rain_activity_id,
      'deprecated': deprecated,
    };
  }
}
