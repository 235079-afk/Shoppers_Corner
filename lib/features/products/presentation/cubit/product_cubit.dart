import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductCubit(this._getProductsUseCase) : super(const ProductInitial());

  Future<void> fetchProducts() async {
    emit(const ProductLoading());

    final result = await _getProductsUseCase();

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
