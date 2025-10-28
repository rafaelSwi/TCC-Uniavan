import 'package:MegaObra/utils/json_serializable.dart';

class ActivityChunkBase implements JsonSerializable {
  final int activity_id;
  final int chunk_id;

  const ActivityChunkBase({
    required this.activity_id,
    required this.chunk_id,
  });

  factory ActivityChunkBase.fromJson(Map<String, dynamic> json) {
    return ActivityChunkBase(
      activity_id: json['activity_id'] as int,
      chunk_id: json['chunk_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'activity_id': activity_id,
      'chunk_id': chunk_id,
    };
  }
}

class ActivityChunk extends ActivityChunkBase {
  final int id;
  final bool deprecated;

  const ActivityChunk({
    required this.id,
    required this.deprecated,
    required super.activity_id,
    required super.chunk_id,
  });

  factory ActivityChunk.fromJson(Map<String, dynamic> json) {
    return ActivityChunk(
      id: json['id'] as int,
      activity_id: json['activity_id'] as int,
      chunk_id: json['chunk_id'] as int,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_id': activity_id,
      'chunk_id': chunk_id,
      'deprecated': deprecated,
    };
  }
}
