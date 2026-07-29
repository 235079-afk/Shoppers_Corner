import '../../domain/entities/cart_item.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded(this.items);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  bool isInCart(String productId) =>
      items.any((item) => item.product.id == productId);

  int quantityOf(String productId) {
    final matches = items.where((item) => item.product.id == productId);
    return matches.isEmpty ? 0 : matches.first.quantity;
  }
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
}
