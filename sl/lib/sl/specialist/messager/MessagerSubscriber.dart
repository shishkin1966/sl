import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class MessagerSubscriber implements SpecialistSubscriber, Stateable {
  void read(Message message);
}
