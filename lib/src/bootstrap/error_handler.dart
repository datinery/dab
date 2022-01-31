import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

import '../exception/handled_exception.dart';

class ErrorHandler {
  void handleError(exception, StackTrace? stackTrace) {
    if (exception is HandledException) {
      debugPrint('Caught HandledException in error handler.');

      if (exception.originalException is DioError) {
        final originalException = exception.originalException as DioError;
        debugPrint(originalException.message);
        debugPrint(originalException.response?.data.toString());
      }

      return;
    }

    debugPrint(exception.toString());
    debugPrint(stackTrace.toString());

    Sentry.captureException(exception, stackTrace: stackTrace);
  }
}
