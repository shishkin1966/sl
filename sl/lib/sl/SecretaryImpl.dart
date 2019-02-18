import 'dart:collection';

import 'package:sl/common/StringUtils.dart';
import 'package:sl/sl/Secretary.dart';

class SecretaryImpl<T> implements Secretary<T> {
  final HashMap<String, T> _subscribers = new HashMap<String, T>();

  @override
  void clear() {
    _subscribers.clear();
  }

  @override
  bool containsKey(String key) {
    if (StringUtils.isNullOrEmpty(key)) return false;

    return _subscribers.containsKey(key);
  }

  @override
  T get(String key) {
    if (StringUtils.isNullOrEmpty(key)) return null;

    if (_subscribers.containsKey(key)) {
      return _subscribers[key];
    }
    return null;
  }

  @override
  bool isEmpty() {
    return _subscribers.isEmpty;
  }

  @override
  List<String> keys() {
    if (_subscribers.isEmpty) return new List();

    List<String> keys = new List();
    for (MapEntry entry in _subscribers.entries) {
      String key = entry.key;
      if (!StringUtils.isNullOrEmpty(key)) keys.add(key);
    }
    return keys;
  }

  @override
  T put(String key, T value) {
    if (value == null) return null;
    if (StringUtils.isNullOrEmpty(key)) return null;

    if (_subscribers.containsKey(key)) {
      _subscribers.remove(key);
    }
    return _subscribers[key] = value;
  }

  @override
  T remove(String key) {
    if (StringUtils.isNullOrEmpty(key)) return null;

    return _subscribers.remove(key);
  }

  @override
  int size() {
    return _subscribers.length;
  }

  @override
  List<T> values() {
    if (_subscribers.isEmpty) return new List();

    List<T> list = new List<T>();
    for (MapEntry entry in _subscribers.entries) {
      if (entry.value != null) list.add(entry.value);
    }
    return list;
  }
}
