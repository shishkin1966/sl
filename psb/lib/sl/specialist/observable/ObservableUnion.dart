import 'package:psb/sl/AbsSmallUnion.dart';
import 'package:psb/sl/observe/Observable.dart';
import 'package:psb/sl/specialist/observable/ObservableSubscriber.dart';

abstract class ObservableUnion extends AbsSmallUnion<ObservableSubscriber> {
  void registerObservable(Observable observable);

  void unregisterObservable(String name);

  C getObservable<C>(final String name);

  List<Observable> getObservables();
}
