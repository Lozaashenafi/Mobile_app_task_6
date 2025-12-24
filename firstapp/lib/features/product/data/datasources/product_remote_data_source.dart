import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchAllProducts();
  Future<ProductModel?> fetchProductById(String id);
  Future<void> addProduct(ProductModel product);
  Future<void> editProduct(ProductModel product);
  Future<void> removeProduct(String id);
}
