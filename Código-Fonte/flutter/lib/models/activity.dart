import 'package:MegaObra/utils/json_serializable.dart';

class ActivityCreate implements JsonSerializable {
  final String description;
  final int location_id;
  final int professional_amount;
  final int laborer_amount;
  final int professional_minutes;
  final int laborer_minutes;
  final int average_labor_cost;
  final DateTime start_date;
  final DateTime deadline_date;
  final int? project_id;
  final List<int> chunks;
  final List<int> restriction;
  final List<int> employee;
  final List<int> materials;
  final List<double> materials_quantity;
  final bool? rain;

  const ActivityCreate({
    required this.description,
    required this.location_id,
    required this.professional_amount,
    required this.laborer_amount,
    required this.professional_minutes,
    required this.laborer_minutes,
    required this.average_labor_cost,
    required this.start_date,
    required this.deadline_date,
    required this.chunks,
    required this.restriction,
    required this.employee,
    required this.materials,
    required this.materials_quantity,
    this.project_id,
    this.rain,
  });

  factory ActivityCreate.fromJson(Map<String, dynamic> json) {
    return ActivityCreate(
      description: json['description'] as String,
      location_id: json['location_id'] as int,
      professional_amount: json['professional_amount'] as int,
      laborer_amount: json['laborer_amount'] as int,
      professional_minutes: json['professional_minutes'] as int,
      laborer_minutes: json['laborer_minutes'] as int,
      average_labor_cost: json['average_labor_cost'] as int,
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      project_id: json['project_id'] != null ? json['project_id'] as int : null,
      chunks: (json['chunks'] as List<dynamic>).map((e) => e as int).toList(),
      restriction: (json['restriction'] as List<dynamic>).map((e) => e as int).toList(),
      employee: (json['employee'] as List<dynamic>).map((e) => e as int).toList(),
      materials: (json['materials'] as List<dynamic>).map((e) => e as int).toList(),
      materials_quantity: (json['materials_quantity'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      rain: json['rain'] != null ? json['rain'] as bool : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = {
      'description': description,
      'location_id': location_id,
      'professional_amount': professional_amount,
      'laborer_amount': laborer_amount,
      'professional_minutes': professional_minutes,
      'laborer_minutes': laborer_minutes,
      'average_labor_cost': average_labor_cost,
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'chunks': chunks,
      'restriction': restriction,
      'employee': employee,
      'materials': materials,
      'materials_quantity': materials_quantity,
      'project_id': project_id,
      'rain': rain,
    };

    return data;
  }
}

class ActivityBase implements JsonSerializable {
  final String description;
  final int location_id;
  final int professional_amount;
  final int laborer_amount;
  final int professional_minutes;
  final int laborer_minutes;
  final int average_labor_cost;
  final bool done;
  final int created_by;
  final DateTime start_date;
  final DateTime deadline_date;
  final DateTime creation_date;
  final DateTime? done_date;

  const ActivityBase({
    required this.description,
    required this.location_id,
    required this.professional_amount,
    required this.laborer_amount,
    required this.professional_minutes,
    required this.laborer_minutes,
    required this.average_labor_cost,
    required this.done,
    required this.created_by,
    required this.creation_date,
    required this.start_date,
    required this.deadline_date,
    this.done_date,
  });

  factory ActivityBase.fromJson(Map<String, dynamic> json) {
    return ActivityBase(
      description: json['description'] as String,
      location_id: json['location_id'] as int,
      professional_amount: json['professional_amount'] as int,
      laborer_amount: json['laborer_amount'] as int,
      professional_minutes: json['professional_minutes'] as int,
      laborer_minutes: json['laborer_minutes'] as int,
      average_labor_cost: json['average_labor_cost'] as int,
      done: json['done'] as bool,
      created_by: json['created_by'] as int,
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      creation_date: DateTime.parse(json['creation_date'] as String),
      done_date: json.containsKey('done_date') ? DateTime.parse(json['done_date'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'location_id': location_id,
      'professional_amount': professional_amount,
      'laborer_amount': laborer_amount,
      'professional_minutes': professional_minutes,
      'laborer_minutes': laborer_minutes,
      'average_labor_cost': average_labor_cost,
      'done': done,
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'created_by': created_by,
      'creation_date': creation_date.toIso8601String(),
      'done_date': done_date?.toIso8601String(),
    };
  }
}

class Activity extends ActivityBase {
  final int id;

  const Activity({
    required this.id,
    required super.description,
    required super.location_id,
    required super.professional_amount,
    required super.laborer_amount,
    required super.professional_minutes,
    required super.laborer_minutes,
    required super.average_labor_cost,
    required super.done,
    required super.created_by,
    required super.creation_date,
    required super.start_date,
    required super.deadline_date,
    super.done_date,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int,
      description: json['description'] as String,
      location_id: json['location_id'] as int,
      professional_amount: json['professional_amount'] as int,
      laborer_amount: json['laborer_amount'] as int,
      professional_minutes: json['professional_minutes'] as int,
      laborer_minutes: json['laborer_minutes'] as int,
      average_labor_cost: json['average_labor_cost'] as int,
      done: json['done'] as bool,
      created_by: json['created_by'] as int,
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      creation_date: DateTime.parse(json['creation_date'] as String),
      done_date: json['done_date'] != null ? DateTime.parse(json['done_date'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'location_id': location_id,
      'professional_amount': professional_amount,
      'laborer_amount': laborer_amount,
      'professional_minutes': professional_minutes,
      'laborer_minutes': laborer_minutes,
      'average_labor_cost': average_labor_cost,
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'done': done,
      'created_by': created_by,
      'creation_date': creation_date.toIso8601String(),
      'done_date': done_date?.toIso8601String(),
    };
  }
}

class ActivityClone implements JsonSerializable {
  final String description;
  final int professional_amount;
  final int laborer_amount;
  final int professional_minutes;
  final int laborer_minutes;
  final int average_labor_cost;
  final DateTime start_date;
  final DateTime deadline_date;
  final List<int> restriction;
  final List<int> materials;
  final List<double> materials_quantity;
  final bool same_project;

  const ActivityClone({
    required this.description,
    required this.professional_amount,
    required this.laborer_amount,
    required this.professional_minutes,
    required this.laborer_minutes,
    required this.average_labor_cost,
    required this.start_date,
    required this.deadline_date,
    required this.restriction,
    required this.materials,
    required this.materials_quantity,
    required this.same_project,
  });

  factory ActivityClone.fromJson(Map<String, dynamic> json) {
    return ActivityClone(
      description: json['description'] as String,
      professional_amount: json['professional_amount'] as int,
      laborer_amount: json['laborer_amount'] as int,
      professional_minutes: json['professional_minutes'] as int,
      laborer_minutes: json['laborer_minutes'] as int,
      average_labor_cost: json['average_labor_cost'] as int,
      start_date: DateTime.parse(json['start_date'] as String),
      deadline_date: DateTime.parse(json['deadline_date'] as String),
      restriction: (json['restriction'] as List<dynamic>).map((e) => e as int).toList(),
      materials: (json['materials'] as List<dynamic>).map((e) => e as int).toList(),
      materials_quantity: (json['materials_quantity'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      same_project: json['same_project'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'professional_amount': professional_amount,
      'laborer_amount': laborer_amount,
      'professional_minutes': professional_minutes,
      'laborer_minutes': laborer_minutes,
      'average_labor_cost': average_labor_cost,
      'start_date': start_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'restriction': restriction,
      'materials': materials,
      'materials_quantity': materials_quantity,
      'same_project': same_project,
    };
  }
}
