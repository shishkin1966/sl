import 'package:sl/sl/AbsSmallUnion.dart';
import 'package:sl/sl/observe/Observable.dart';
import 'package:sl/sl/specialist/observable/ObservableSubscriber.dart';
import 'package:sl/sl/specialist/observable/ObservableUnion.dart';

class ObservableUnionImpl extends AbsSmallUnion<ObservableSubscriber> implements ObservableUnion {
  static const String NAME = "ObservableUnionImpl";

  @override
  int compareTo(other) {
    return (other is ObservableUnion) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  Observable getObservable(String name) {
    // TODO: implement getObservable
    return null;
  }

  @override
  List<Observable> getObservables() {
    // TODO: implement getObservables
    return null;
  }

  @override
  void registerObservable(Observable observable) {}

  @override
  void unregisterObservable(String name) {
    // TODO: implement unregisterObservable
  }
}
