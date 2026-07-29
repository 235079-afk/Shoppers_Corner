import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await _localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(DataMappingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addToCart(Product product) async {
    try {
      final items = await _localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == product.id);

      if (index != -1) {
        items[index] = CartItemModel(
          product: items[index].product,
          quantity: items[index].quantity + 1,
        );
      } else {
        items.add(CartItemModel(product: product));
      }

      await _localDataSource.saveCartItems(items);
      return Right(items);
    } catch (e) {
      return Left(DataMappingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> removeFromCart(
    String productId,
  ) async {
    try {
      final items = await _localDataSource.getCartItems();
      items.removeWhere((item) => item.product.id == productId);
      await _localDataSource.saveCartItems(items);
      return Right(items);
    } catch (e) {
      return Left(DataMappingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final items = await _localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == productId);

      if (index != -1) {
        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index] = CartItemModel(
            product: items[index].product,
            quantity: quantity,
          );
        }
      }

      await _localDataSource.saveCartItems(items);
      return Right(items);
    } catch (e) {
      return Left(DataMappingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> clearCart() async {
    try {
      await _localDataSource.saveCartItems([]);
      return const Right([]);
    } catch (e) {
      return Left(DataMappingFailure(e.toString()));
    }
  }
}
