import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryCubit(this._getCategoriesUseCase) : super(const CategoryInitial());

  Future<void> fetchCategories() async {
    emit(const CategoryLoading());

    final result = await _getCategoriesUseCase();

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
