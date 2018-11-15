import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class ObservableSubscriber<T> extends SpecialistSubscriber implements Stateable {
  List<String> getObservable();

  void onChange<T>(T object);
}
