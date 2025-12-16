import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double size;
  final String category;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.category,
    this.rating = 0.0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    price,
    size,
    category,
    rating,
  ];
}
