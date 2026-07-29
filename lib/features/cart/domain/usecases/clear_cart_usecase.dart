import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call() {
    return repository.clearCart();
  }
}
