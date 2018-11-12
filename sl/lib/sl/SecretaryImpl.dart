import 'dart:collection';

import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/util/StringUtils.dart';

class SecretaryImpl<T> implements Secretary<T> {
  final HashMap<String, T> subscribers = new HashMap<String, T>();

  @override
  void clear() {
    subscribers.clear();
  }

  @override
  bool containsKey(String key) {
    if (StringUtils.isNullOrEmpty(key)) return false;

    return subscribers.containsKey(key);
  }

  @override
  T get(String key) {
    if (StringUtils.isNullOrEmpty(key)) return null;

    if (subscribers.containsKey(key)) {
      return subscribers[key];
    }
    return null;
  }

  @override
  bool isEmpty() {
    return subscribers.isEmpty;
  }

  @override
  List<String> keys() {
    return subscribers.keys;
  }

  @override
  T put(String key, T value) {
    if (value == null) return null;
    if (StringUtils.isNullOrEmpty(key)) return null;

    if (subscribers.containsKey(key)) {
      subscribers.remove(key);
    }
    return subscribers[key] = value;
  }

  @override
  T remove(String key) {
    if (StringUtils.isNullOrEmpty(key)) return null;

    return subscribers.remove(key); // ignore: return_of_invalid_type
  }

  @override
  int size() {
    return subscribers.length;
  }

  @override
  List<T> values() {
    List<T> list = new List<T>();
    list.addAll(subscribers.values);
    return list;
  }
}
