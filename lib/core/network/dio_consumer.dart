import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';
import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
 

  DioConsumer(this._client, this.interceptor);

    final Dio _client;
  final List<Interceptor> interceptor ;

  @override
  Future<Either<Failure, dynamic>> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _client.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleError(error));
    }
  }

  @override
  Future<Either<Failure, dynamic>> post({
    required String path,
    required Object body,
    String? contentType,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _client.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(contentType: contentType, headers: headers),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleError(error));
    }
  }

  @override
  Future<Either<Failure, dynamic>> put({
    required String path,
    required Object body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _client.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleError(error));
    }
  }

  @override
  Future<Either<Failure, dynamic>> delete({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _client.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleError(error));
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Connection timed out');
      case DioExceptionType.connectionError:
        return const ServerFailure('No internet connection');
      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        final message = data is Map ? data['message']?.toString() : null;
        return ServerFailure(
          message ?? 'Server error (${error.response?.statusCode})',
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ServerFailure(error.message ?? 'Something went wrong');
      case DioExceptionType.transformTimeout:
        throw UnimplementedError();
    }
  }
}
