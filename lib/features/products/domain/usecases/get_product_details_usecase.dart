import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, Product>> call(String id) {
    return repository.getProductDetails(id);
  }
}
