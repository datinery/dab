import 'dart:collection';

import 'package:flutter/material.dart';

typedef KeyFunction<T, K> = K Function(T element);

class BaseState<T, K> extends ChangeNotifier {
  final KeyFunction<T, K> keyFunction;

  LinkedHashMap<K, T> _itemsMap = LinkedHashMap<K, T>();

  BaseState({required this.keyFunction});

  List<T> get items => _itemsMap.values.toList();
  LinkedHashMap<K, T> get itemsMap => _itemsMap;

  void replaceAll(List<T> items) {
    _itemsMap = _createLinkedHashMap(items);
    notifyListeners();
  }

  void unshift(T item) {
    final items = _itemsMap.values.toList();
    items.insert(0, item);
    _itemsMap = _createLinkedHashMap(items);
    notifyListeners();
  }

  void insert(int index, T item) {
    final items = _itemsMap.values.toList();
    items.insert(index, item);
    _itemsMap = _createLinkedHashMap(items);
    notifyListeners();
  }

  void add(List<T> items) {
    if (items.isEmpty) {
      return;
    }

    _itemsMap.addAll(_createLinkedHashMap(items));
    notifyListeners();
  }

  void updateItem(T item) {
    _itemsMap.update(keyFunction(item), (_) => item);
    notifyListeners();
  }

  void remove(K itemId) {
    _itemsMap.remove(itemId);
    notifyListeners();
  }

  LinkedHashMap<K, T> _createLinkedHashMap(List<T> items) {
    return LinkedHashMap.fromIterable(
      items,
      key: (e) => keyFunction(e as T),
    );
  }
}
