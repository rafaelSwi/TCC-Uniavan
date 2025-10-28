import 'package:MegaObra/utils/json_serializable.dart';

class ActivityRestrictionBase implements JsonSerializable {
  final int activity_id;
  final int restriction_id;

  const ActivityRestrictionBase({
    required this.activity_id,
    required this.restriction_id,
  });

  factory ActivityRestrictionBase.fromJson(Map<String, dynamic> json) {
    return ActivityRestrictionBase(
      activity_id: json['activity_id'] as int,
      restriction_id: json['restriction_id'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'activity_id': activity_id,
      'restriction_id': restriction_id,
    };
  }
}

class ActivityRestriction extends ActivityRestrictionBase {
  final int id;
  final bool deprecated;

  const ActivityRestriction({
    required this.id,
    required this.deprecated,
    required super.activity_id,
    required super.restriction_id,
  });

  factory ActivityRestriction.fromJson(Map<String, dynamic> json) {
    return ActivityRestriction(
      id: json['id'] as int,
      activity_id: json['activity_id'] as int,
      restriction_id: json['restriction_id'] as int,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_id': activity_id,
      'restriction_id': restriction_id,
      'deprecated': deprecated,
    };
  }
}
