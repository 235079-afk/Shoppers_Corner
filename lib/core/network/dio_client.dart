import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static Dio create({List<Interceptor> interceptors = const []}) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.addAll(interceptors);

    return dio;
  }
}
