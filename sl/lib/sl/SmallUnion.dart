import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/Specialist.dart';

abstract class SmallUnion<T> implements Specialist {
  Secretary<T> createSecretary<T>();

  bool checkSubscriber<T>(T subscriber);

  bool registerSubscriber<T>(T subscriber);

  void unregisterSubscriber<T>(T subscriber);

  void unregisterByName(String name);

  List<T> getSubscribers<T>();

  List<T> getValidatedSubscribers<T>();

  List<T> getReadySubscribers<T>();

  bool hasSubscribers();

  bool hasSubscriber(String name);

  T getSubscriber<T>(String name);

  void onRegisterFirstSubscriber();

  void onUnRegisterLastSubscriber();

  void onAddSubscriber<T>(T subscriber);
}
