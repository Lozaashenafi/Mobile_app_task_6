import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase implements UseCase<Product?, String> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product?> call(String id) {
    return repository.getProductById(id);
  }
}
