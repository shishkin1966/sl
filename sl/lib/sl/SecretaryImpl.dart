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
    return _subscribers.keys;
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

    return _subscribers.remove(key); // ignore: return_of_invalid_type
  }

  @override
  int size() {
    return _subscribers.length;
  }

  @override
  List<T> values() {
    List<T> list = new List<T>();
    list.addAll(_subscribers.values);
    return list;
  }
}
