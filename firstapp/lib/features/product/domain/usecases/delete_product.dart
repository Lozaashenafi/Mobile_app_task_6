import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUsecase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(String id) {
    return repository.deleteProduct(id);
  }
}
