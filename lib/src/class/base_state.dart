import 'dart:collection';

import 'package:flutter/material.dart';

class BaseState<T, S> extends ChangeNotifier {
  @protected
  LinkedHashMap<S, T> storedItems = LinkedHashMap<S, T>();

  List<T> get items => storedItems.values.toList();

  void replaceAll(List<T> items) {
    storedItems = LinkedHashMap.fromIterable(items, key: (v) => v.id);

    notifyListeners();
  }

  void unshift(T item) {
    final items = [item, ...storedItems.values];
    storedItems = LinkedHashMap.fromIterable(items, key: (e) => e.id);

    notifyListeners();
  }

  void add(List<T> items) {
    if (items.isEmpty) {
      return;
    }

    storedItems.addAll(LinkedHashMap.fromIterable(items, key: (v) => v.id));

    notifyListeners();
  }

  void updateItem(item) {
    storedItems.update(item.id, (_) => item);

    notifyListeners();
  }

  void remove(S itemId) {
    storedItems.remove(itemId);

    notifyListeners();
  }
}
