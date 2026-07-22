import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

abstract class ApiConsumer {
  Future<Either<Failure, dynamic>> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Failure, dynamic>> post({
    required String path,
    required Object body,
    String? contentType,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<Failure, dynamic>> put({
    required String path,
    required Object body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Failure, dynamic>> delete({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}
