import 'package:psb/sl/Specialist.dart';
import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/Subscriber.dart';

///
/// Service Locator - обеспечивает функционирование и взаимодействие
/// специалистов
///
abstract class ServiceLocator implements Subscriber {
  ///
  /// Проверить проверить наличие специалиста
  ///
  /// @param key имя специалиста
  /// @return true - специалист присутствует
  ///
  bool exists(final String name);

  ///
  /// Получить специалиста
  ///
  /// @param key имя специалиста
  /// @return T - специалист
  ///
  T get<T extends Specialist>(String name);

  ///
  /// Зарегистрировать специалиста
  ///
  /// @param specialist специалист
  /// @return true - специалист зарегистрирован
  ///
  bool registerSpecialist(Specialist specialist);

  ///
  /// Зарегистрировать специалиста по его имени
  ///
  /// @param specialist имя специалиста
  /// @return true - специалист зарегистрирован
  ///
  bool registerSpecialistByName(String specialist);

  ///
  /// Отменить регистрацию специалиста
  ///
  /// @param specialist имя специалиста
  /// @return true - регистрация отменена
  ///
  bool unregisterSpecialist(String name);

  ///
  /// Зарегистрировать подписчика специалиста
  ///
  /// @param subscriber подписчик специалиста
  /// @return true - подписчик специалиста зарегистрирован
  ///
  bool registerSubscriber(SpecialistSubscriber subscriber);

  ///
  /// Отменить регистрацию подписчика специалиста
  ///
  /// @param subscriber подписчик специалиста
  /// @return true - регистрация отменена
  ///
  bool unregisterSubscriber(SpecialistSubscriber subscriber);

  ///
  /// Установить подписчика специалиста текущим
  ///
  /// @param subscriber подписчик специалиста
  /// @return true - операция завершена удачно
  ///
  bool setCurrentSubscriber(SpecialistSubscriber subscriber);

  ///
  /// Получить полный список специалистов
  ///
  /// @return список специалистов
  ///
  List<Specialist> getSpecialists();

  ///
  /// Остановить работу специалистов
  ///
  void stop();

  ///
  /// Очистить
  ///
  void clear();
}
