import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/local_keys.dart';
import '../local_storage/base_local_storage.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors({required BaseLocalStorage localStorage})
      : _localStorage = localStorage;

  final BaseLocalStorage _localStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _localStorage.getString(LocalKeys.accessToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      log('REQUEST[${options.method}] => PATH: ${options.path}');
      log('Has token: ${token != null && token.isNotEmpty}');
      log('Headers: ${options.headers}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      log(
        'Sent headers: ${err.requestOptions.headers}',
      );
      if (err.response?.data != null) {
        log('Error data: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}
