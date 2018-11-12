import 'package:sl/sl/Subscriber.dart';
import 'package:sl/sl/Validated.dart';

abstract class SpecialistSubscriber implements Subscriber, Validated {
  List<String> getSpecialistSubscription();
}
