import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class MessagerSubscriber extends SpecialistSubscriber implements Stateable {
  void read(Message message);
}
