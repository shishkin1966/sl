abstract class Secretary<T> {
  T remove(String key);

  int size();

  T put(String key, T value);

  bool containsKey(String key);

  T get(String key);

  List<T> values();

  bool isEmpty();

  void clear();

  List<String> keys();
}
