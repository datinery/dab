import 'dart:collection';

class LRU<K, V> {
  final LinkedHashMap<K, V> _map = LinkedHashMap<K, V>();
  final int maxCount;

  LRU(this.maxCount);

  V? get(K key) {
    var value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  void put(K key, V value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > maxCount) {
      _map.remove(_map.keys.first);
    }
  }
}
