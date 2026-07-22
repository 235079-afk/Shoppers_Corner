import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../models/product_model.dart';
import '../models/products_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> fetchProducts();

  Future<Either<Failure, ProductModel>> fetchProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ProductRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ProductModel>>> fetchProducts() async {
    final result = await _apiConsumer.get(path: ApiConstants.productsUrl);

    return result.flatMap((data) {
      try {
        final responseModel = ProductsResponseModel.fromJson(
          data as Map<String, dynamic>,
        );
        return Right(responseModel.items);
      } catch (e) {
        return Left(DataMappingFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, ProductModel>> fetchProductById(String id) async {
    final result = await _apiConsumer.get(
      path: ApiConstants.productDetailsUrl(id),
    );

    return result.flatMap((data) {
      try {
        return Right(ProductModel.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        return Left(DataMappingFailure(e.toString()));
      }
    });
  }
}
