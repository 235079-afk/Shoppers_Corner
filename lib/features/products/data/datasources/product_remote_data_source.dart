import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSource(this._dio);

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get(ApiConstants.productsUrl);

    final data = response.data as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    return items
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
