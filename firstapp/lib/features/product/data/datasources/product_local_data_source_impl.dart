import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedProductsKey = 'CACHED_PRODUCTS';

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString != null) {
      final List decodeData = json.decode(jsonString);
      return decodeData.map((p) => ProductModel.fromJson(p)).toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) async {
    final jsonString = json.encode(
      productsToCache.map((p) => p.toJson()).toList(),
    );
    await sharedPreferences.setString(cachedProductsKey, jsonString);
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final products = await getLastProducts();
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProduct(ProductModel productToCache) async {
    List<ProductModel> products = [];
    try {
      products = await getLastProducts();
      // Remove existing version if it exists (to avoid duplicates)
      products.removeWhere((p) => p.id == productToCache.id);
    } catch (e) {
      // If cache was empty, start with empty list
    }
    products.add(productToCache);
    await cacheProducts(products);
  }
}
