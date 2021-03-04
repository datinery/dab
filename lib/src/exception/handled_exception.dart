class HandledException<T extends Exception> implements Exception {
  final T originalException;

  HandledException(this.originalException);
}
