import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailsCubit(this._getProductDetailsUseCase)
      : super(const ProductDetailsInitial());

  Future<void> fetchProductDetails(String id) async {
    emit(const ProductDetailsLoading());

    final result = await _getProductDetailsUseCase(id);

    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }
}
