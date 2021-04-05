import 'dart:async';
import 'dart:isolate';

import 'package:dab/src/bootstrap/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bootstrap({
  required Widget child,
  String? sentryDsn,
  Function? onBindingInitialized,
}) async {
  if (kReleaseMode) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  final errorHandler = ErrorHandler(dsn: sentryDsn);

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Platform error
      Isolate.current.addErrorListener(RawReceivePort((pair) {
        final exception = pair.first;
        final stackTrace = pair.last;

        errorHandler.handleError(exception, stackTrace);
      }).sendPort);

      // Flutter error
      FlutterError.onError = (FlutterErrorDetails details) =>
          errorHandler.handleError(details.exception, details.stack);

      if (onBindingInitialized != null) await onBindingInitialized();

      runApp(child);
    },
    (exception, stackTrace) => errorHandler.handleError(exception, stackTrace),
  );
}
