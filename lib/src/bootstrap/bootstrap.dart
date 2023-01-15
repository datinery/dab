import 'dart:async';
import 'dart:isolate';

import 'package:dab/dab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ErrorCallback = Function(dynamic exception, StackTrace? stackTrace);

bootstrap({
  required Widget child,
  required ErrorCallback onError,
  required Function? onBindingInitialized,
}) async {
  FutureBuilder.debugRethrowError = true;

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Platform error
      if (!kIsWeb) {
        Isolate.current.addErrorListener(RawReceivePort((pair) {
          final exception = pair.first;
          final stackTrace = pair.last;

          _handleError(exception, stackTrace, onError);
        }).sendPort);
      }

      // Flutter error
      FlutterError.onError = (FlutterErrorDetails details) =>
          _handleError(details.exception, details.stack, onError);

      if (onBindingInitialized != null) await onBindingInitialized();

      runApp(child);
    },
    (exception, stackTrace) => _handleError(exception, stackTrace, onError),
  );
}

void _handleError(
  dynamic exception,
  StackTrace? stackTrace,
  ErrorCallback? onError,
) {
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

  onError?.call(exception, stackTrace);
}
