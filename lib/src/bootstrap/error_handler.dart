import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
import 'package:dio/dio.dart';

import '../exception/handled_exception.dart';

class ErrorHandler {
  ErrorHandler({String? dsn}) {
    if (kReleaseMode) {
      Sentry.init((options) {
        options.dsn = dsn;
      });
    }
  }

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

    if (kReleaseMode) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
