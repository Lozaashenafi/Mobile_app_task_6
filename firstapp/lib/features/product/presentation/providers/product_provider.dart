import 'package:flutter/material.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../../domain/usecases/view_product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';

class ProductProvider extends ChangeNotifier {
  final ViewAllProductsUsecase viewAllProducts;
  final ViewProductUsecase viewProduct;
  final CreateProductUsecase createProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;

  ProductProvider({
    required this.viewAllProducts,
    required this.viewProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  });

  List<Product> products = [];
  Product? selectedProduct;

  /// LOAD ALL PRODUCTS
  Future<void> loadProducts() async {
    products = await viewAllProducts(NoParams());
    notifyListeners();
  }

  /// GET SINGLE PRODUCT
  Future<void> loadProductById(String id) async {
    selectedProduct = await viewProduct(id);
    notifyListeners();
  }

  /// ADD PRODUCT
  Future<void> addProduct(Product product) async {
    await createProduct(product);
    await loadProducts();
  }

  /// UPDATE PRODUCT
  Future<void> editProduct(Product product) async {
    await updateProduct(product);
    await loadProducts();
  }

  /// DELETE PRODUCT
  Future<void> removeProduct(String id) async {
    await deleteProduct(id);
    await loadProducts();
  }
}
