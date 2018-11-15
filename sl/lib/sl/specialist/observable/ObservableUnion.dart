import 'package:sl/sl/AbsSmallUnion.dart';
import 'package:sl/sl/observe/Observable.dart';
import 'package:sl/sl/specialist/observable/ObservableSubscriber.dart';

abstract class ObservableUnion extends AbsSmallUnion<ObservableSubscriber> {
  void registerObservable(Observable observable);

  void unregisterObservable(String name);

  C getObservable<C>(final String name);

  List<Observable> getObservables();
}
