import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/message/Message.dart';
import 'package:psb/sl/state/Stateable.dart';

///
/// Messenger подписчик
///
abstract class MessengerSubscriber extends SpecialistSubscriber implements Stateable {
  ///
  /// Читать сообщение
  ///
  /// @param message сообщение
  ///
  void read(Message message);
}
