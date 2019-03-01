import 'package:psb/sl/Subscriber.dart';
import 'package:psb/sl/specialist/messager/MessengerSubscriber.dart';

abstract class Message extends Subscriber {
  void read(MessengerSubscriber subscriber);

  bool contains(String address);

  int getId();

  Message setId(int id);

  Message copy();

  List<String> getCopyTo();

  Message setCopyTo(List<String> copyTo);

  String getAddress();

  Message setAddress(String address);

  bool isCheckDublicate();

  String getSender();

  Message setSender(String sender);

  int getEndTime();

  Message setEndTime(int keepAliveTime);
}
