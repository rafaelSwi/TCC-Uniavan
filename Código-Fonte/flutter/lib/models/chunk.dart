import 'package:MegaObra/utils/json_serializable.dart';

class Chunk implements JsonSerializable {
  final String info_one;
  final String info_two;
  final String info_three;
  final bool deprecated;

  const Chunk({
    required this.info_one,
    required this.info_two,
    required this.info_three,
    required this.deprecated,
  });

  factory Chunk.fromJson(Map<String, dynamic> json) {
    return Chunk(
      info_one: json['info_one'] as String,
      info_two: json['info_two'] as String,
      info_three: json['info_three'] as String,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'info_one': info_one,
      'info_two': info_two,
      'info_three': info_three,
      'deprecated': deprecated,
    };
  }
}

class ChunkCreate implements JsonSerializable {
  final int location_id;
  final String info_one;
  final String info_two;
  final String info_three;

  const ChunkCreate({
    required this.location_id,
    required this.info_one,
    required this.info_two,
    required this.info_three,
  });

  factory ChunkCreate.fromJson(Map<String, dynamic> json) {
    return ChunkCreate(
      location_id: json['location_id'] as int,
      info_one: json['info_one'] as String,
      info_two: json['info_two'] as String,
      info_three: json['info_three'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'location_id': location_id,
      'info_one': info_one,
      'info_two': info_two,
      'info_three': info_three,
    };
  }
}

class LocationChunk extends ChunkCreate {
  final int id;

  const LocationChunk({
    required this.id,
    required super.location_id,
    required super.info_one,
    required super.info_two,
    required super.info_three,
  });

  factory LocationChunk.fromJson(Map<String, dynamic> json) {
    return LocationChunk(
      id: json['id'] as int,
      location_id: json['location_id'] as int,
      info_one: json['info_one'] as String,
      info_two: json['info_two'] as String,
      info_three: json['info_three'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location_id': location_id,
      'info_one': info_one,
      'info_two': info_two,
      'info_three': info_three,
    };
  }
}

class ChunkStatusCreate implements JsonSerializable {
  final int activity_id;
  final int location_info_chunk_id;
  final bool status;

  const ChunkStatusCreate({
    required this.activity_id,
    required this.location_info_chunk_id,
    required this.status,
  });

  factory ChunkStatusCreate.fromJson(Map<String, dynamic> json) {
    return ChunkStatusCreate(
      activity_id: json['activity_id'] as int,
      location_info_chunk_id: json['location_info_chunk_id'] as int,
      status: json['status'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'activity_id': activity_id,
      'location_info_chunk_id': location_info_chunk_id,
      'status': status,
    };
  }
}

class ChunkStatus extends ChunkStatusCreate {
  final int id;
  final DateTime creation_date;
  final DateTime? done_date;
  final DateTime? mark_done_date;
  final int? mark_done_by;

  const ChunkStatus({
    required this.id,
    required this.creation_date,
    this.done_date,
    this.mark_done_date,
    required super.activity_id,
    required super.location_info_chunk_id,
    required super.status,
    this.mark_done_by,
  });

  factory ChunkStatus.fromJson(Map<String, dynamic> json) {
    return ChunkStatus(
      id: json['id'] as int,
      creation_date: DateTime.parse(json['creation_date'] as String),
      done_date: json.containsKey('done_date') && json['done_date'] != null ? DateTime.parse(json['done_date'] as String) : null,
      mark_done_date: json.containsKey('mark_done_date') && json['mark_done_date'] != null
          ? DateTime.parse(json['mark_done_date'] as String)
          : null,
      activity_id: json['activity_id'] as int,
      location_info_chunk_id: json['location_info_chunk_id'] as int,
      status: json['status'] as bool,
      mark_done_by: json['mark_done_by'] != null ? json['break_in'] as int : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_id': activity_id,
      'location_info_chunk_id': location_info_chunk_id,
      'status': status,
      'creation_date': creation_date.toIso8601String(),
      'done_date': done_date?.toIso8601String(),
      'mark_done_date': mark_done_date?.toIso8601String(),
      'mark_done_by': mark_done_by,
    };
  }
}

class CompleteChunk implements JsonSerializable {
  final int chunk_id;
  final int status_id;
  final int location_id;
  final int activity_id;
  final String info_one;
  final String info_two;
  final String info_three;
  final DateTime creation_date;
  final DateTime? done_date;
  final DateTime? mark_done_date;
  final int? mark_done_by;
  bool status;

  CompleteChunk({
    required this.chunk_id,
    required this.status_id,
    required this.location_id,
    required this.activity_id,
    required this.info_one,
    required this.info_two,
    required this.info_three,
    required this.status,
    required this.creation_date,
    this.done_date,
    this.mark_done_date,
    this.mark_done_by,
  });

  factory CompleteChunk.fromJson(Map<String, dynamic> json) {
    return CompleteChunk(
      chunk_id: json['chunk_id'] as int,
      status_id: json['status_id'] as int,
      location_id: json['location_id'] as int,
      activity_id: json['activity_id'] as int,
      info_one: json['info_one'] as String,
      info_two: json['info_two'] as String,
      info_three: json['info_three'] as String,
      status: json['status'] as bool,
      creation_date: DateTime.parse(json['creation_date'] as String),
      done_date: json.containsKey('done_date') && json['done_date'] != null ? DateTime.parse(json['done_date'] as String) : null,
      mark_done_date: json.containsKey('mark_done_date') && json['mark_done_date'] != null
          ? DateTime.parse(json['mark_done_date'] as String)
          : null,
      mark_done_by: json['mark_done_by'] != null ? json['mark_done_by'] as int : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'chunk_id': chunk_id,
      'status_id': status_id,
      'location_id': location_id,
      'activity_id': activity_id,
      'info_one': info_one,
      'info_two': info_two,
      'info_three': info_three,
      'status': status,
      'creation_date': creation_date.toIso8601String(),
      'done_date': done_date?.toIso8601String(),
      'mark_done_date': mark_done_date?.toIso8601String(),
      'mark_done_by': mark_done_by,
    };
  }
}
