import 'package:collection/collection.dart';

extension ListExtension<T> on List<T> {
  T? get mode {
    final counts = <T, int>{};

    for (var i = 0; i < length; i++) {
      counts[this[i]] == null
          ? counts[this[i]] = 1
          : counts[this[i]] = counts[this[i]]! + 1;
    }

    var most = (counts.values.toList()..sort()).last;

    return counts.keys.firstWhereOrNull((e) => counts[e] == most);
  }
}
