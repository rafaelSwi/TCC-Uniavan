import 'package:MegaObra/utils/json_serializable.dart';

class ProjectSuperSimplified implements JsonSerializable {
  final int id;
  final String title;
  final DateTime start_date;
  final DateTime deadline_date;
  final DateTime? deactivation_date;
  final int responsible_id;
  final String responsible_name;

  const ProjectSuperSimplified({
    required this.id,
    required this.title,
    required this.start_date,
    required this.deactivation_date,
    required this.deadline_date,
    required this.responsible_id,
    required this.responsible_name,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'deactivation_date': deactivation_date?.toIso8601String(),
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'responsible_id': responsible_id,
      'responsible_name': responsible_name,
    };
  }

  factory ProjectSuperSimplified.fromJson(Map<String, dynamic> json) {
    return ProjectSuperSimplified(
      id: json['id'] as int,
      title: json['title'] as String,
      start_date: DateTime.parse(json['start_date'] as String),
      deactivation_date: json['deactivation_date'] != null ? DateTime.parse(json['deactivation_date'] as String) : null,
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      responsible_id: json['responsible_id'] as int,
      responsible_name: json['responsible_name'] as String,
    );
  }
}

class ProjectCreate implements JsonSerializable {
  final DateTime start_date;
  final DateTime deadline_date;
  final String title;
  final bool active;
  final int responsible_id;
  final List<int> rain;
  final List<int> employee;
  final List<int> activity;

  const ProjectCreate({
    required this.start_date,
    required this.title,
    required this.deadline_date,
    required this.active,
    required this.responsible_id,
    required this.rain,
    required this.employee,
    required this.activity,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'active': active,
      'title': title,
      'responsible_id': responsible_id,
      'rain': rain,
      'employee': employee,
      'activity': activity,
    };
  }

  factory ProjectCreate.fromJson(Map<String, dynamic> json) {
    return ProjectCreate(
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      title: json['title'] as String,
      active: json['active'] as bool,
      responsible_id: json['responsible_id'] as int,
      rain: List<int>.from(json['rain'] as List<dynamic>),
      employee: List<int>.from(json['employee'] as List<dynamic>),
      activity: List<int>.from(json['activity'] as List<dynamic>),
    );
  }
}

class ProjectBase implements JsonSerializable {
  final DateTime start_date;
  final DateTime deadline_date;
  final String title;
  final bool active;
  final int responsible_id;
  final int created_by;
  final DateTime creation_date;
  final DateTime? deactivation_date;

  const ProjectBase({
    required this.start_date,
    required this.title,
    required this.deadline_date,
    required this.active,
    required this.responsible_id,
    required this.created_by,
    required this.creation_date,
    this.deactivation_date,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'title': title,
      'active': active,
      'responsible_id': responsible_id,
      'created_by': created_by,
      'creation_date': creation_date.toIso8601String(),
      'deactivation_date': deactivation_date?.toIso8601String(),
    };
  }

  factory ProjectBase.fromJson(Map<String, dynamic> json) {
    return ProjectBase(
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      active: json['active'] as bool,
      title: json['title'] as String,
      responsible_id: json['responsible_id'] as int,
      created_by: json['created_by'] as int,
      creation_date: DateTime.parse(json['creation_date'] as String),
      deactivation_date: json.containsKey('deactivation_date') && json['deactivation_date'] != null
          ? DateTime.parse(json['deactivation_date'] as String)
          : null,
    );
  }
}

class Project extends ProjectBase {
  final int id;

  const Project({
    required this.id,
    required super.start_date,
    required super.title,
    required super.deadline_date,
    required super.active,
    required super.responsible_id,
    required super.created_by,
    required super.creation_date,
    super.deactivation_date,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'active': active,
      'title': title,
      'responsible_id': responsible_id,
      'created_by': created_by,
      'creation_date': creation_date.toIso8601String(),
      'deactivation_date': deactivation_date?.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      active: json['active'] as bool,
      responsible_id: json['responsible_id'] as int,
      created_by: json['created_by'] as int,
      creation_date: DateTime.parse(json['creation_date'] as String),
      deactivation_date: json.containsKey('deactivation_date') && json['deactivation_date'] != null
          ? DateTime.parse(json['deactivation_date'] as String)
          : null,
    );
  }
}

class ProjectEdit implements JsonSerializable {
  final int id;
  final String title;
  final DateTime start_date;
  final DateTime deadline_date;
  final int responsible_id;
  final List<int> rain;
  final List<int> employee;
  final List<int> activity;

  const ProjectEdit({
    required this.id,
    required this.start_date,
    required this.title,
    required this.deadline_date,
    required this.responsible_id,
    required this.rain,
    required this.employee,
    required this.activity,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'responsible_id': responsible_id,
      'rain': rain,
      'employee': employee,
      'activity': activity,
    };
  }

  factory ProjectEdit.fromJson(Map<String, dynamic> json) {
    return ProjectEdit(
      id: json['id'] as int,
      title: json['title'] as String,
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      responsible_id: json['responsible_id'] as int,
      rain: List<int>.from(json['rain'] as List<dynamic>),
      employee: List<int>.from(json['employee'] as List<dynamic>),
      activity: List<int>.from(json['activity'] as List<dynamic>),
    );
  }
}
