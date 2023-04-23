import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../exception/handled_exception.dart';

typedef FutureFunction<T> = Future<Response<T>> Function();
typedef DioErrorCallback = Function(BuildContext? context, DioError e);

class DabHttpClient {
  late final Dio _dio;
  final DioErrorCallback? _onClientError;
  final DioErrorCallback? _onServerError;

  BaseOptions get options => _dio.options;
  Interceptors get interceptors => _dio.interceptors;

  DabHttpClient({
    DioErrorCallback? onClientError,
    DioErrorCallback? onServerError,
    bool? useMemCache,
    bool? useHiveCache,
    String? baseUrl,
    int connectTimeout = 5000,
    int sendTimeout = 5000,
    int receiveTimeout = 5000,
  })  : _onClientError = onClientError,
        _onServerError = onServerError {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: Duration(milliseconds: connectTimeout),
      sendTimeout: Duration(milliseconds: sendTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
    ));

    if (useMemCache == true) {
      _dio.interceptors.add(
          DioCacheInterceptor(options: CacheOptions(store: MemCacheStore())));
    }

    if (useHiveCache == true) {
      getTemporaryDirectory().then((dir) {
        _dio.interceptors.add(DioCacheInterceptor(
            options: CacheOptions(store: HiveCacheStore(dir.path))));
      });
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
      if (e.type == DioErrorType.unknown && e.error is SocketException) {
        if (_onClientError != null) {
          _onClientError!(context, e);
        }

        throw HandledException<DioError>(e);
      }

      if (e.type == DioErrorType.badResponse) {
        if (_onServerError != null) {
          _onServerError!(context, e);
        }

        throw HandledException<DioError>(e);
      }

      rethrow;
    }
  }
}
