import 'package:sl/sl/SmallUnion.dart';

abstract class Union<T> implements SmallUnion<T> {
  T getCurrentSubscriber<T>();

  void setCurrentSubscriber<T>(T subscriber);
}
