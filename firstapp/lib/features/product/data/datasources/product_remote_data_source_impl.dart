import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // Populate with your initial data
  final List<ProductModel> _mockProducts = [
    const ProductModel(
      id: '1',
      name: 'Running Shoe',
      description: 'A derby leather shoe is a classic and versatile footwear.',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      price: 79.99,
      size: 42,
      category: 'Sports',
      rating: 4.0,
    ),
  ];

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts;
  }

  @override
  Future<ProductModel?> fetchProductById(String id) async {
    try {
      return _mockProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    _mockProducts.add(product);
  }

  @override
  Future<void> editProduct(ProductModel product) async {
    final index = _mockProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _mockProducts[index] = product;
    }
  }

  @override
  Future<void> removeProduct(String id) async {
    _mockProducts.removeWhere((p) => p.id == id);
  }
}
