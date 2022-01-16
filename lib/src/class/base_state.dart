import 'dart:collection';

import 'package:flutter/material.dart';

typedef KeyFunction<K> = K Function(dynamic element);

class BaseState<T, K> extends ChangeNotifier {
  final KeyFunction<K>? _keyFunction;

  BaseState({KeyFunction<K>? keyFunction}) : _keyFunction = keyFunction;

  @protected
  LinkedHashMap<K, T> storedItems = LinkedHashMap<K, T>();

  List<T> get items => storedItems.values.toList();

  void replaceAll(List<T> items) {
    storedItems = LinkedHashMap.fromIterable(items, key: _keyFunction ?? (e) => e.id);

    notifyListeners();
  }

  void unshift(T item) {
    final items = [item, ...storedItems.values];
    storedItems = LinkedHashMap.fromIterable(items, key: _keyFunction ?? (e) => e.id);

    notifyListeners();
  }

  void add(List<T> items) {
    if (items.isEmpty) {
      return;
    }

    storedItems.addAll(LinkedHashMap.fromIterable(items, key: _keyFunction ?? (e) => e.id));

    notifyListeners();
  }

  void updateItem(item) {
    storedItems.update(item.id, (_) => item);

    notifyListeners();
  }

  void remove(K itemId) {
    storedItems.remove(itemId);

    notifyListeners();
  }
}
