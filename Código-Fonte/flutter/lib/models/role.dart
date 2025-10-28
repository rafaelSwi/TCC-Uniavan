import 'package:MegaObra/utils/json_serializable.dart';

class RoleBase implements JsonSerializable {
  final String role_name;

  const RoleBase({
    required this.role_name,
  });

  factory RoleBase.fromJson(Map<String, dynamic> json) {
    return RoleBase(
      role_name: json['role_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'role_name': role_name,
    };
  }
}

class Role extends RoleBase {
  final int id;

  const Role({
    required this.id,
    required super.role_name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      role_name: json['role_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_name': role_name,
    };
  }
}
