import 'package:sl/sl/Subscriber.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';

abstract class Message extends Subscriber {
  void read(MessagerSubscriber subscriber);

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
