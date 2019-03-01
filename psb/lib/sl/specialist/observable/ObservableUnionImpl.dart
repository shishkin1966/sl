import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/AbsSmallUnion.dart';
import 'package:psb/sl/Secretary.dart';
import 'package:psb/sl/SecretaryImpl.dart';
import 'package:psb/sl/observe/Observable.dart';
import 'package:psb/sl/specialist/observable/ObservableSubscriber.dart';
import 'package:psb/sl/specialist/observable/ObservableUnion.dart';

class ObservableUnionImpl extends AbsSmallUnion<ObservableSubscriber> implements ObservableUnion {
  static const String NAME = "ObservableUnionImpl";

  Secretary<Observable> _observableSecretary = new SecretaryImpl();

  @override
  int compareTo(other) {
    return (other is ObservableUnion) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  C getObservable<C>(String name) {
    if (_observableSecretary.containsKey(name)) {
      return _observableSecretary.get(name) as C;
    }
    return null;
  }

  @override
  List<Observable> getObservables() {
    final List<Observable> list = new List();
    for (Observable observable in _observableSecretary.values()) {
      if (observable != null) {
        list.add(observable);
      }
    }
    return list;
  }

  @override
  void registerObservable(Observable observable) {
    if (observable == null) return;

    _observableSecretary.put(observable.getName(), observable);
  }

  @override
  void unregisterObservable(String name) {
    if (StringUtils.isNullOrEmpty(name)) return;

    if (_observableSecretary.containsKey(name)) {
      _observableSecretary.get(name).unregister();
      _observableSecretary.remove(name);
    }
  }

  @override
  bool registerSubscriber<T>(final T subscriber) {
    if (subscriber == null) return false;

    if (super.registerSubscriber(subscriber)) {
      final List<String> list = (subscriber as ObservableSubscriber).getObservable();
      if (list != null) {
        for (Observable observable in _observableSecretary.values()) {
          if (observable != null) {
            final String name = observable.getName();
            if (list.contains(name)) {
              observable.addObserver(subscriber as ObservableSubscriber);
            }
          }
        }
      }
      return true;
    }
    return false;
  }

  @override
  void unregisterSubscriber<T>(final T subscriber) {
    if (subscriber == null) return;

    super.unregisterSubscriber(subscriber);

    final List<String> list = (subscriber as ObservableSubscriber).getObservable();
    if (list != null) {
      for (Observable observable in _observableSecretary.values()) {
        if (observable != null) {
          if (list.contains(observable.getName())) {
            observable.removeObserver(subscriber as ObservableSubscriber);
          }
        }
      }
    }
  }
}
