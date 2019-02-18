///
/// Секретарь - ведет учет членов объединения
///
abstract class Secretary<T> {
  ///
  /// Удалить члена объединения
  ///
  /// @return член объединения
  ///
  T remove(String key);

  ///
  /// Получить размер объединения
  ///
  /// @return размер объединения
  ///
  int size();

  ///
  /// Добавить члена в объединение
  ///
  /// @param key имя члена объединения
  /// @param T член объединения
  ///
  T put(String key, T value);

  ///
  ///  Проверить наличие члена в объединении
  ///
  /// @param key имя члена объединения
  /// @return true - входит в объединения
  ///
  bool containsKey(String key);

  ///
  ///  Получить члена объединения
  ///
  /// @param key имя члена объединения
  /// @return T член объединения
  ///
  T get(String key);

  ///
  ///  Получить всех членов объединения
  ///
  /// @return члены объединения
  ///
  List<T> values();

  ///
  ///  Проверить отсутствие членов объединения
  ///
  /// @return true - члены отсутствуют
  ///
  bool isEmpty();

  ///
  ///  Удалить всех членов объединения
  ///
  void clear();

  ///
  ///  Получить список имен членов объединения
  ///
  /// @return список имен
  ///
  List<String> keys();
}
