import 'package:sl/sl/Subscriber.dart';
import 'package:sl/sl/Validated.dart';

///
/// Подписчик специалиста
///
abstract class SpecialistSubscriber implements Subscriber, Validated {
  ///
  /// Получить список имен подписываемых специалистов
  ///
  /// @return список имен подписываемых специалистов
  ///
  List<String> getSpecialistSubscription();
}
