import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/products_response_model.dart';

class ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSource(this._dio);

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get(ApiConstants.productsUrl);

    final responseModel = ProductsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return responseModel.items;
  }
}
