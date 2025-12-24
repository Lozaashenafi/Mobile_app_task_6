import '../../../../core/platform/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.fetchAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (e) {
        return await localDataSource.getLastProducts();
      }
    } else {
      return await localDataSource.getLastProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      final remoteProduct = await remoteDataSource.fetchProductById(id);
      if (remoteProduct != null) {
        await localDataSource.cacheProduct(remoteProduct);
      }
      return remoteProduct;
    } else {
      return await localDataSource.getProductById(id);
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      size: product.size,
      category: product.category,
      rating: product.rating,
    );

    if (await networkInfo.isConnected) {
      await remoteDataSource.addProduct(model);
    }
    // Always cache locally as well
    await localDataSource.cacheProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      size: product.size,
      category: product.category,
      rating: product.rating,
    );

    if (await networkInfo.isConnected) {
      await remoteDataSource.editProduct(model);
    }
    await localDataSource.cacheProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.removeProduct(id);
    }
    // Update local cache by removing it
    final products = await localDataSource.getLastProducts();
    products.removeWhere((p) => p.id == id);
    await localDataSource.cacheProducts(products);
  }
}
