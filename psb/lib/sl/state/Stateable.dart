///
/// Имеющий состояние
///
abstract class Stateable {
  ///
  /// Получить состояние
  ///
  /// @return состояние
  ///
  String getState();

  ///
  /// Установить состояние
  ///
  /// @param state состояние
  ///
  void setState(String state);
}
