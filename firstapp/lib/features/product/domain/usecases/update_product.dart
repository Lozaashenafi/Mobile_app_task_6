import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase implements UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}
