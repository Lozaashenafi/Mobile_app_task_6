import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/usecases/view_all_products.dart';
import 'features/product/domain/usecases/view_product.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/screens/home_page.dart';

void main() {
  final repository = ProductRepositoryImpl();

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
        home: const HomePage(),
      ),
    );
  }
}
