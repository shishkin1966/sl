import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/specialist/messager/MessengerSubscriber.dart';

abstract class MessengerUnion extends SmallUnion<MessengerSubscriber> {
  readMessages(MessengerSubscriber subscriber);

  List<Message> getMessages(MessengerSubscriber subscriber);

  void removeMessage(Message message);

  void clearMessages(MessengerSubscriber subscriber);

  addMessagingList(String name, List<String> addresses);

  void removeMessagingList(String name);

  List<String> getMessagingList(String name);

  void addMessage(Message message);

  void addNotMandatoryMessage(Message message);
}
