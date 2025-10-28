import 'package:MegaObra/utils/json_serializable.dart';

class PermissionBase implements JsonSerializable {
  final String permission_name;

  const PermissionBase({
    required this.permission_name,
  });

  factory PermissionBase.fromJson(Map<String, dynamic> json) {
    return PermissionBase(
      permission_name: json['permission_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'permission_name': permission_name,
    };
  }
}

class Permission extends PermissionBase {
  final int id;

  const Permission({
    required this.id,
    required super.permission_name,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as int,
      permission_name: json['permission_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'permission_name': permission_name,
    };
  }
}
