import 'package:sl/sl/Subscriber.dart';
import 'package:sl/sl/Validated.dart';

abstract class Specialist implements Subscriber, Validated, Comparable {
  bool isPersistent();

  void onUnRegister();

  void onRegister();

  void stop();
}
