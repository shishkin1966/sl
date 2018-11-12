import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';

abstract class Union<T extends SpecialistSubscriber> implements SmallUnion<T> {
  T getCurrentSubscriber<T extends SpecialistSubscriber>();

  void setCurrentSubscriber<T extends SpecialistSubscriber>(T subscriber);
}
