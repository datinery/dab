extension IterableExtension<T> on Iterable<T?> {
  Iterable<T> whereNotNull() {
    return this.where((e) => e != null).toList() as Iterable<T>;
  }
}
