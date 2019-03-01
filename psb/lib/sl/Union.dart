import 'package:psb/sl/SmallUnion.dart';

///
/// Объединение специалистов
///
abstract class Union<T> implements SmallUnion<T> {
  ///
  /// Получить текущего специалиста
  ///
  /// @return теущийспециалист
  ///
  T getCurrentSubscriber<T>();

  ///
  /// Установить текущего специалиста
  ///
  /// @param subscriber специалист
  ///
  void setCurrentSubscriber<T>(T subscriber);
}
