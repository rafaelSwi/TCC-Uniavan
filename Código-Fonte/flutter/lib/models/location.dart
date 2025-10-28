import 'package:MegaObra/utils/json_serializable.dart';

class LocationBase implements JsonSerializable {
  final String enterprise;
  final String cep;
  final String description;
  final bool deprecated;

  const LocationBase({
    required this.enterprise,
    required this.cep,
    required this.description,
    required this.deprecated,
  });

  factory LocationBase.fromJson(Map<String, dynamic> json) {
    return LocationBase(
      enterprise: json['enterprise'] as String,
      cep: json['cep'] as String,
      description: json['description'] as String,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'enterprise': enterprise,
      'cep': cep,
      'description': description,
      'deprecated': deprecated,
    };
  }
}

class Location extends LocationBase {
  final int id;

  const Location({
    required this.id,
    required super.enterprise,
    required super.cep,
    required super.description,
    required super.deprecated,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      enterprise: json['enterprise'] as String,
      cep: json['cep'] as String,
      description: json['description'] as String,
      deprecated: json['deprecated'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enterprise': enterprise,
      'cep': cep,
      'description': description,
      'deprecated': deprecated,
    };
  }
}
