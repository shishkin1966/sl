import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';

abstract class MessagerUnion extends SmallUnion<MessagerSubscriber> {
  readMessages(MessagerSubscriber subscriber);

  List<Message> getMessages(MessagerSubscriber subscriber);

  void removeMessage(Message message);

  void clearMessages(MessagerSubscriber subscriber);

  addMessagingList(String name, List<String> addresses);

  void removeMessagingList(String name);

  List<String> getMessagingList(String name);

  void addMessage(Message message);

  void addNotMandatoryMessage(Message message);
}
