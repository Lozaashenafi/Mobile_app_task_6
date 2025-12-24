import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);
  Future<ProductModel> getProductById(String id);
  Future<void> cacheProduct(ProductModel productToCache);
}
