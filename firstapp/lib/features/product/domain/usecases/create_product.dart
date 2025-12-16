import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase implements UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) {
    return repository.createProduct(product);
  }
}
