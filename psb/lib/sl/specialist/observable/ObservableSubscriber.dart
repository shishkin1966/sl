import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/state/Stateable.dart';

abstract class ObservableSubscriber<T> extends SpecialistSubscriber implements Stateable {
  List<String> getObservable();

  void onChange<T>(T object);
}
