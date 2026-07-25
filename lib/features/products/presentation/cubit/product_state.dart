import '../../domain/entities/product.dart';

sealed class ProductState {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}

class ProductDetailsLoading extends ProductState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductState {
  final Product product;
  const ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductState {
  final String message;
  const ProductDetailsError(this.message);
}
