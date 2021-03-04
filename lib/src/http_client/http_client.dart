import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../exception/handled_exception.dart';

typedef FutureFunction<T> = Future<Response<T>> Function();
typedef ErrorHandler = Function(DioError e);

class HttpClient {
  final Dio _dio = Dio();
  final ErrorHandler? _onClientError;
  final ErrorHandler? _onServerError;

  BaseOptions get options => _dio.options;
  Interceptors get interceptors => _dio.interceptors;

  HttpClient({
    ErrorHandler? onClientError,
    ErrorHandler? onServerError,
    connectTimeout = 3000,
    sendTimeout = 3000,
    receiveTimeout = 3000,
  })  : _onClientError = onClientError,
        _onServerError = onServerError {
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.sendTimeout = sendTimeout;
    _dio.options.receiveTimeout = receiveTimeout;

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(onRequest: (options) {
          debugPrint(options.uri.toString());
          debugPrint(options.data.toString());
        }),
      );
    }
  }

  Future<Response<T>> get<T>(
    BuildContext? context,
    String? path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.get<T>(
        path!,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<Response<T>> post<T>(
    BuildContext? context,
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
    );
  }

  /*
   * Handles common errors with alerts and toasts.
   */
  Future<Response<T>> withHttpErrorHandler<T>(
      BuildContext? context, FutureFunction<T> futureFunction) async {
    try {
      return await futureFunction();
    } on DioError catch (e) {
      if ([
            DioErrorType.connectTimeout,
            DioErrorType.sendTimeout,
            DioErrorType.receiveTimeout,
          ].contains(e.type) ||
          (e.type == DioErrorType.other && e.error is SocketException)) {
        if (context != null && _onClientError != null) {
          _onClientError!(e);
        }

        throw HandledException<DioError>(e);
      }

      if (e.type == DioErrorType.response) {
        if (context != null && _onServerError != null) {
          _onServerError!(e);
        }

        throw HandledException<DioError>(e);
      }

      rethrow;
    }
  }
}
