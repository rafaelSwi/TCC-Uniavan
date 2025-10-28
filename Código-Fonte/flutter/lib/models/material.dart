import 'package:MegaObra/utils/json_serializable.dart';

class MaterialBase implements JsonSerializable {
  final String name;
  final String? description;
  final double? averagePrice;
  final String? measure;
  final bool inStock;

  const MaterialBase({
    required this.name,
    this.description,
    this.averagePrice,
    this.measure,
    this.inStock = true,
  });

  factory MaterialBase.fromJson(Map<String, dynamic> json) {
    return MaterialBase(
      name: json['name'] as String,
      description: json['description'] as String?,
      averagePrice: (json['average_price'] as num?)?.toDouble(),
      measure: json['measure'] as String?,
      inStock: json['in_stock'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'average_price': averagePrice,
      'measure': measure,
      'in_stock': inStock,
    };
  }
}

class Material extends MaterialBase {
  final int id;

  const Material({
    required this.id,
    required super.name,
    super.description,
    super.averagePrice,
    super.measure,
    super.inStock,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      averagePrice: (json['average_price'] as num?)?.toDouble(),
      measure: json['measure'] as String?,
      inStock: json['in_stock'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'average_price': averagePrice,
      'measure': measure,
      'in_stock': inStock,
    };
  }
}
