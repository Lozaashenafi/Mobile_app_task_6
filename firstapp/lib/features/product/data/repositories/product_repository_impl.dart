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
        // Error Handling: Fallback to local cache if remote fails
        return await localDataSource.getLastProducts();
      }
    } else {
      // Error Handling: Use local cache if offline
      return await localDataSource.getLastProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.fetchProductById(id);
        if (remoteProduct != null) {
          await localDataSource.cacheProduct(remoteProduct);
        }
        return remoteProduct;
      } catch (e) {
        return await localDataSource.getProductById(id);
      }
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
    // Always update local cache to ensure consistency (Best Practice)
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

    final products = await localDataSource.getLastProducts();
    products.removeWhere((p) => p.id == id);
    await localDataSource.cacheProducts(products);
  }
}
