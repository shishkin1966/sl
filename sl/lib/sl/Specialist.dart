import 'package:sl/sl/Subscriber.dart';
import 'package:sl/sl/Validated.dart';

///
/// Специалист
///
abstract class Specialist implements Subscriber, Validated, Comparable {
  ///
  /// Проверить работает ли специалист постоянно
  ///
  /// @return true - специалист постоянный
  ///
  bool isPersistent();

  ///
  /// Событие, вызываемое при отмене регистрации специалиста
  ///
  void onUnRegister();

  ///
  /// Событие, вызываемое при регистрации специалиста
  ///
  void onRegister();

  ///
  /// Остановить работу специалиста
  ///
  void stop();
}
