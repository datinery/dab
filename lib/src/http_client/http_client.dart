import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';

import '../exception/handled_exception.dart';

typedef FutureFunction<T> = Future<Response<T>> Function();
typedef ErrorCallback = Function(BuildContext context, DioError e);

class HttpClient {
  late final Dio _dio;
  final ErrorCallback? _onClientError;
  final ErrorCallback? _onServerError;

  BaseOptions get options => _dio.options;
  Interceptors get interceptors => _dio.interceptors;

  HttpClient({
    ErrorCallback? onClientError,
    ErrorCallback? onServerError,
    bool? useMemCache,
    String? baseUrl,
    int? connectTimeout,
    int? sendTimeout,
    int? receiveTimeout,
  })  : _onClientError = onClientError,
        _onServerError = onServerError {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: connectTimeout ?? 3000,
      sendTimeout: sendTimeout ?? 3000,
      receiveTimeout: receiveTimeout ?? 3000,
    ));

    if (useMemCache == true) {
      _dio.interceptors.add(
          DioCacheInterceptor(options: CacheOptions(store: MemCacheStore())));
    }
  }

  Future<Response<T>> get<T>(
    BuildContext? context,
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.get<T>(
        path,
        queryParameters: query,
        options: options,
      ),
    );
  }

  Future<Response<T>> post<T>(
    BuildContext? context,
    String path, {
    data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
      ),
    );
  }

  Future<Response<T>> put<T>(
    BuildContext? context,
    String path, {
    data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    BuildContext? context,
    String path, {
    data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return await withHttpErrorHandler<T>(
      context,
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
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
      ].contains(e.type)) {
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

      rethrow;
    }
  }
}
