const String tableProducts = 'products';

class ProductFields {
  static final List<String> values = [
    id,
    name,
    quantity,
    price,
    imagePath,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String quantity = 'quantity';
  static const String price = 'price';
  static const String imagePath = 'image_path';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copy({
    int? id,
    String? name,
    int? quantity,
    double? price,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        imagePath: imagePath ?? this.imagePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Product fromJson(Map<String, Object?> json) => Product(
    id: json[ProductFields.id] as int?,
    name: json[ProductFields.name] as String,
    quantity: json[ProductFields.quantity] as int,
    price: json[ProductFields.price] as double,
    imagePath: json[ProductFields.imagePath] as String?,
    createdAt: DateTime.parse(json[ProductFields.createdAt] as String),
    updatedAt: DateTime.parse(json[ProductFields.updatedAt] as String),
  );

  Map<String, Object?> toJson() => {
    ProductFields.id: id,
    ProductFields.name: name,
    ProductFields.quantity: quantity,
    ProductFields.price: price,
    ProductFields.imagePath: imagePath,
    ProductFields.createdAt: createdAt.toIso8601String(),
    ProductFields.updatedAt: updatedAt.toIso8601String(),
  };
}