import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.size,
    required super.category,
    super.rating,
  });

  // Convert JSON to ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      size: (json['size'] as num).toDouble(),
      category: json['category'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'category': category,
      'rating': rating,
    };
  }
}
