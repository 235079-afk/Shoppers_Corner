import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductCubit(this._getProductsUseCase, this._getProductDetailsUseCase)
      : super(const ProductInitial());

  Future<void> fetchProducts() async {
    emit(const ProductLoading());

    final result = await _getProductsUseCase();

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  Future<void> fetchProductDetails(String id) async {
    emit(const ProductDetailsLoading());

    final result = await _getProductDetailsUseCase(id);

    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }
}
