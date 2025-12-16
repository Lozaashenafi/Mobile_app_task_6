import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required double price,
    required double size,
    required String category,
    double rating = 0.0,
  }) : super(
         id: id,
         name: name,
         description: description,
         imageUrl: imageUrl,
         price: price,
         size: size,
         category: category,
         rating: rating,
       );
}
