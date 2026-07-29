import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call(
    String productId,
    int quantity,
  ) {
    return repository.updateQuantity(productId, quantity);
  }
}
