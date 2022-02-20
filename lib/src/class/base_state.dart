import 'dart:collection';

import 'package:flutter/material.dart';

typedef KeyFunction<T, K> = K Function(T element);

class BaseState<T, K> extends ChangeNotifier {
  final KeyFunction<T, K>? _keyFunction;

  BaseState({KeyFunction<T, K>? keyFunction}) : _keyFunction = keyFunction;

  @protected
  LinkedHashMap<K, T> storedItems = LinkedHashMap<K, T>();

  List<T> get items => storedItems.values.toList();

  void replaceAll(List<T> items) {
    storedItems = _createLinkedHashMap(items);
    notifyListeners();
  }

  void unshift(T item) {
    final items = [item, ...storedItems.values];
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

  void updateItem(item) {
    storedItems.update(item.id, (_) => item);
    notifyListeners();
  }

  void remove(K itemId) {
    storedItems.remove(itemId);
    notifyListeners();
  }

  LinkedHashMap<K, T> _createLinkedHashMap(List<T> items) {
    return LinkedHashMap.fromIterable(
      items,
      key: _keyFunction != null ? (e) => _keyFunction!(e as T) : (e) => e.id,
    );
  }
}
