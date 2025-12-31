import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Core
import 'core/platform/network_info.dart';

// Data Sources
import 'features/product/data/datasources/product_remote_data_source_impl.dart';
import 'features/product/data/datasources/product_local_data_source_impl.dart';

// Repository
import 'features/product/data/repositories/product_repository_impl.dart';

// Usecases
import 'features/product/domain/usecases/view_all_products.dart';
import 'features/product/domain/usecases/view_product.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/delete_product.dart';

// Presentation
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final connectionChecker = InternetConnectionChecker.createInstance();

  // 2. Initialize Data Sources (Concrete Implementations)
  final remoteDataSource = ProductRemoteDataSourceImpl();
  final localDataSource = ProductLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  // 3. Initialize Network Info
  final networkInfo = NetworkInfoImpl(connectionChecker);

  // 4. Inject dependencies into the Repository
  final repository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProductRepositoryImpl repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ProductProvider(
            viewAllProducts: ViewAllProductsUsecase(repository),
            viewProduct: ViewProductUsecase(repository),
            createProduct: CreateProductUsecase(repository),
            updateProduct: UpdateProductUsecase(repository),
            deleteProduct: DeleteProductUsecase(repository),
          )..loadProducts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF3F51B5),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
