import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();

  Future<Either<Failure, List<CartItem>>> addToCart(Product product);

  Future<Either<Failure, List<CartItem>>> removeFromCart(String productId);

  Future<Either<Failure, List<CartItem>>> updateQuantity(
    String productId,
    int quantity,
  );

  Future<Either<Failure, List<CartItem>>> clearCart();
}
