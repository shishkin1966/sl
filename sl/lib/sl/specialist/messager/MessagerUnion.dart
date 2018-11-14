import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';

abstract class MessagerUnion extends SmallUnion<MessagerSubscriber> {
  readMessages(MessagerSubscriber subscriber);

  List<Message> getMessage(MessagerSubscriber subscriber);

  void removeMessage(Message message);

  void clearMail(MessagerSubscriber subscriber);

  addMailingList(String name, List<String> addresses);

  void removeMailingList(String name);

  List<String> getMailingList(String name);
}
