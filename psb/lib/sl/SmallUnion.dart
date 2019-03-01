import 'package:psb/sl/Secretary.dart';
import 'package:psb/sl/Specialist.dart';

///
/// Малое объединение специалистов
///
abstract class SmallUnion<T> implements Specialist {
  ///
  /// Создать секретаря объединения
  ///
  /// @return секретарь объединения
  ///
  Secretary<T> createSecretary<T>();

  ///
  /// Проверить специалиста
  ///
  /// @param subscriber специалист
  /// @return true - специалист прошел проверку
  ///
  bool checkSubscriber<T>(T subscriber);

  ///
  /// Зарегистрировать специалиста в объединении
  ///
  /// @param subscriber специалист
  /// @return true - специалист зарегистрирован
  ///
  bool registerSubscriber<T>(T subscriber);

  ///
  /// Отменить регистрацию специалиста в объединении
  ///
  /// @param subscriber специалист
  ///
  void unregisterSubscriber<T>(T subscriber);

  ///
  /// Отменить регистрацию специалиста в объединении по имени специалиста
  ///
  /// @param name имя специалиста
  ///
  void unregisterByName(String name);

  ///
  /// Получить полный список специалистов
  ///
  /// @return список специалистов
  ///
  List<T> getSubscribers<T>();

  ///
  /// Получить список проверенных специалистов
  ///
  /// @return список специалистов
  ///
  List<T> getValidatedSubscribers<T>();

  ///
  /// Получить список готовых к деятельности специалистов
  ///
  /// @return список специалистов
  ///
  List<T> getReadySubscribers<T>();

  ///
  /// Проверить наличие специалистов
  ///
  /// @return true - специалисты есть
  ///
  bool hasSubscribers();

  ///
  /// Проверить наличие специалиста
  ///
  /// @param name имя специалиста
  /// @return true - специалист есть
  ///
  bool hasSubscriber(String name);

  ///
  /// Получить специалиста
  ///
  /// @param name имя специалиста
  /// @return специалист
  ///
  T getSubscriber<T>(String name);

  ///
  /// Событие, вызываемое при регистрации первого специалиста
  ///
  void onRegisterFirstSubscriber();

  ///
  /// Событие, вызываемое при отмене регистрации последнего специалиста
  ///
  void onUnRegisterLastSubscriber();

  ///
  /// Событие, вызываемое при регистрации специалиста
  ///
  /// @param subscriber специалист
  ///
  void onAddSubscriber<T>(T subscriber);
}
