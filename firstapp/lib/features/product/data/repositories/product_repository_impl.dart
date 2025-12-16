import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Running Shoe',
      description:
          'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system.',
      imageUrl: 'assets/images/shoe.jpg',
      price: 79.99,
      size: 42,
      category: 'Sports',
    ),
    Product(
      id: '2',
      name: 'Casual Sneaker',
      description: 'Stylish sneaker for everyday wear',
      imageUrl: 'assets/images/shoe.jpg',
      price: 99.99,
      size: 42,
      category: 'Sports',
    ),
    Product(
      id: '3',
      name: 'Sport Trainer',
      description: 'Comfortable trainer for sports',
      imageUrl: 'assets/images/shoe.jpg',
      price: 89.99,
      size: 42,
      category: 'Sports',
    ),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}
