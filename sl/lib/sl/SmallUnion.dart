import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/Specialist.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';

abstract class SmallUnion<T extends SpecialistSubscriber> implements Specialist {
  Secretary<T> createSecretary<T extends SpecialistSubscriber>();

  bool checkSubscriber<T extends SpecialistSubscriber>(T subscriber);

  bool registerSubscriber<T extends SpecialistSubscriber>(T subscriber);

  void unregisterSubscriber<T extends SpecialistSubscriber>(T subscriber);

  void unregisterByName(String name);

  List<T> getSubscribers<T extends SpecialistSubscriber>();

  List<T> getValidatedSubscribers<T extends SpecialistSubscriber>();

  List<T> getReadySubscribers<T extends SpecialistSubscriber>();

  bool hasSubscribers();

  bool hasSubscriber(String name);

  T getSubscriber<T extends SpecialistSubscriber>(String name);

  void onRegisterFirstSubscriber();

  void onUnRegisterLastSubscriber();

  void onAddSubscriber(T subscriber);
}
