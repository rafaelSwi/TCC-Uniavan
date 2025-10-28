import 'package:MegaObra/utils/json_serializable.dart';

class UserCreate implements JsonSerializable {
  final String name;
  final String cpf;
  final String password;
  final int role_id;
  final int permission_id;
  final int schedule_id;

  const UserCreate({
    required this.name,
    required this.cpf,
    required this.password,
    required this.role_id,
    required this.permission_id,
    required this.schedule_id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cpf': cpf,
      'password': password,
      'role_id': role_id,
      'permission_id': permission_id,
      'schedule_id': schedule_id,
    };
  }

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      password: json['password'] as String,
      role_id: json['role_id'] as int,
      permission_id: json['permission_id'] as int,
      schedule_id: json['schedule_id'] as int,
    );
  }
}

class UserBase implements JsonSerializable {
  final String name;
  final String cpf;
  final int role_id;
  final int schedule_id;
  final int permission_id;

  const UserBase({
    required this.name,
    required this.cpf,
    required this.role_id,
    required this.schedule_id,
    required this.permission_id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cpf': cpf,
      'role_id': role_id,
      'schedule_id': schedule_id,
      'permission_id': permission_id,
    };
  }

  factory UserBase.fromJson(Map<String, dynamic> json) {
    return UserBase(
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      role_id: json['role_id'] as int,
      schedule_id: json['schedule_id'] as int,
      permission_id: json['permission_id'] as int,
    );
  }
}

class User extends UserBase {
  final int id;

  const User({
    required this.id,
    required super.name,
    required super.cpf,
    required super.role_id,
    required super.schedule_id,
    required super.permission_id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'role_id': role_id,
      'schedule_id': schedule_id,
      'permission_id': permission_id,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      role_id: json['role_id'] as int,
      schedule_id: json['schedule_id'] as int,
      permission_id: json['permission_id'] as int,
    );
  }
}
