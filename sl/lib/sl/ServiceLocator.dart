import 'package:sl/sl/Specialist.dart';
import 'package:sl/sl/SpecialistFactory.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/Subscriber.dart';

abstract class ServiceLocator implements Subscriber {
  bool exists(final String name);

  T get<T extends Specialist>(String name);

  bool registerSpecialist(Specialist specialist);

  bool registerSpecialistByName(String specialist);

  bool unregisterSpecialist(String name);

  bool registerSubscriber(SpecialistSubscriber subscriber);

  bool unregisterSubscriber(SpecialistSubscriber subscriber);

  bool setCurrentSubscriber(SpecialistSubscriber subscriber);

  void onStop();

  void onStart();

  SpecialistFactory getSpecialistFactory();

  List<Specialist> getSpecialists();
}
