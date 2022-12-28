import 'dart:collection';

import 'package:flutter/material.dart';

typedef KeyFunction<T, K> = K Function(T element);

class BaseState<T, K> extends ChangeNotifier {
  final KeyFunction<T, K> keyFunction;

  BaseState({required this.keyFunction});

  @protected
  LinkedHashMap<K, T> storedItems = LinkedHashMap<K, T>();

  List<T> get items => storedItems.values.toList();

  void replaceAll(List<T> items) {
    storedItems = _createLinkedHashMap(items);
    notifyListeners();
  }

  void unshift(T item) {
    final items = storedItems.values.toList();
    items.insert(0, item);
    storedItems = _createLinkedHashMap(items);
    notifyListeners();
  }

  void insert(int index, T item) {
    final items = storedItems.values.toList();
    items.insert(index, item);
    storedItems = _createLinkedHashMap(items);
    notifyListeners();
  }

  void add(List<T> items) {
    if (items.isEmpty) {
      return;
    }

    storedItems.addAll(_createLinkedHashMap(items));
    notifyListeners();
  }

  void updateItem(T item) {
    storedItems.update(keyFunction(item), (_) => item);
    notifyListeners();
  }

  void remove(K itemId) {
    storedItems.remove(itemId);
    notifyListeners();
  }

  LinkedHashMap<K, T> _createLinkedHashMap(List<T> items) {
    return LinkedHashMap.fromIterable(
      items,
      key: keyFunction != null ? (e) => keyFunction(e as T) : (e) => e.id,
    );
  }
}
