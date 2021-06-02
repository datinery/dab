import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../exception/handled_exception.dart';

typedef FutureFunction<T> = Future<Response<T>> Function();
typedef ErrorHandler = Function(BuildContext context, DioError e);

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
        InterceptorsWrapper(onRequest: (options, handler) {
          debugPrint(options.uri.toString());
          debugPrint(options.data.toString());
          debugPrint(options.headers.toString());
          handler.next(options);
        }),
      );
    }
  }

  Future<Response<T>> get<T>(
    BuildContext? context,
    String path, {
    Map<String, dynamic>? query,
  }) async {
      return await withHttpErrorHandler<T>(
        context,
            () => _dio.get<T>(
          path,
          queryParameters: query,
        ),
      );
  }

  Future<Response<T>> post<T>(
    BuildContext? context,
    String path, {
    data,
    Map<String, dynamic>? query,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: query,
      ),
    );
  }

  Future<Response<T>> put<T>(
      BuildContext? context,
      String path, {
        data,
        Map<String, dynamic>? query,
      }) async {
    return await withHttpErrorHandler<T>(
      context,
          () => _dio.put<T>(
        path,
        data: data,
        queryParameters: query,
      ),
    );
  }

  Future<Response<T>> delete<T>(
      BuildContext? context,
      String path, {
        data,
        Map<String, dynamic>? query,
      }) async {
    return await withHttpErrorHandler<T>(
      context,
          () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: query,
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
          ].contains(e.type) ) {
        if (context != null && _onClientError != null) {
          _onClientError!(context, e);
        }

        throw HandledException<DioError>(e);
      }

      if (e.type == DioErrorType.response ||
          (e.type == DioErrorType.other && e.error is SocketException)) {
        if (context != null && _onServerError != null) {
          _onServerError!(context, e);
        }

        throw HandledException<DioError>(e);
      }

      throw e;
    }
  }
}
