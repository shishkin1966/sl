import 'package:psb/sl/Subscriber.dart';
import 'package:psb/sl/Validated.dart';

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
