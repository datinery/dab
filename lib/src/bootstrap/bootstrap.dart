import 'dart:async';
import 'dart:isolate';

import 'package:dab/src/bootstrap/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

bootstrap({
  required Widget child,
  String? sentryDsn,
  Function? onBindingInitialized,
}) async {
  FutureBuilder.debugRethrowError = true;
  final errorHandler = ErrorHandler();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SentryFlutter.init((options) {
        options.dsn = sentryDsn;
        options.environment = kReleaseMode ? 'prod' : 'dev';
        options.debug = false;
      });

      // Platform error
      if (!kIsWeb) {
        Isolate.current.addErrorListener(RawReceivePort((pair) {
          final exception = pair.first;
          final stackTrace = pair.last;

          errorHandler.handleError(exception, stackTrace);
        }).sendPort);
      }

      // Flutter error
      FlutterError.onError = (FlutterErrorDetails details) =>
          errorHandler.handleError(details.exception, details.stack);

      if (onBindingInitialized != null) await onBindingInitialized();

      runApp(child);
    },
    (exception, stackTrace) => errorHandler.handleError(exception, stackTrace),
  );
}
