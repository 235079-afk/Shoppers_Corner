import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Either<Failure, List<CategoryModel>>> fetchCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiConsumer _apiConsumer;

  CategoryRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<CategoryModel>>> fetchCategories() async {
    final result = await _apiConsumer.get(path: ApiConstants.categoriesUrl);

    return result.flatMap((data) {
      try {
        List<dynamic> rawList = const [];

        if (data is List && data.isNotEmpty && data.first is Map) {
          rawList = (data.first as Map<String, dynamic>)['categories']
                  as List<dynamic>? ??
              const [];
        } else if (data is Map<String, dynamic>) {
          rawList = data['categories'] as List<dynamic>? ?? const [];
        } else if (data is List) {
          rawList = data;
        }

        final categories = rawList
            .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return Right(categories);
      } catch (e) {
        return Left(DataMappingFailure(e.toString()));
      }
    });
  }
}
