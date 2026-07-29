import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartItemsUseCase _getCartItemsUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateCartQuantityUseCase _updateCartQuantityUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartCubit(
    this._getCartItemsUseCase,
    this._addToCartUseCase,
    this._removeFromCartUseCase,
    this._updateCartQuantityUseCase,
    this._clearCartUseCase,
  ) : super(const CartInitial());

  Future<void> fetchCart() async {
    emit(const CartLoading());
    final result = await _getCartItemsUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> addToCart(Product product) async {
    final result = await _addToCartUseCase(product);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> incrementQuantity(String productId) async {
    final current = state;
    if (current is! CartLoaded) return;
    await _updateQuantity(productId, current.quantityOf(productId) + 1);
  }

  Future<void> decrementQuantity(String productId) async {
    final current = state;
    if (current is! CartLoaded) return;
    await _updateQuantity(productId, current.quantityOf(productId) - 1);
  }

  Future<void> _updateQuantity(String productId, int quantity) async {
    final result = await _updateCartQuantityUseCase(productId, quantity);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> removeFromCart(String productId) async {
    final result = await _removeFromCartUseCase(productId);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> clearCart() async {
    final result = await _clearCartUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }
}
