import 'package:sl/sl/message/Message.dart';

abstract class MessagerSubscriber {
  void read(Message message);
}
