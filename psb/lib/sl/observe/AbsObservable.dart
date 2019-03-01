import 'package:psb/sl/Secretary.dart';
import 'package:psb/sl/SecretaryImpl.dart';
import 'package:psb/sl/observe/Observable.dart';
import 'package:psb/sl/specialist/observable/ObservableSubscriber.dart';

abstract class AbsObservable<K extends ObservableSubscriber> implements Observable<K> {
  Secretary _secretary = new SecretaryImpl();

  @override
  void addObserver<K extends ObservableSubscriber>(K subscriber) {
    if (subscriber == null) return;

    _secretary.put(subscriber.getName(), subscriber);

    if (_secretary.size() == 1) {
      register();
    }
  }

  @override
  List<K> getObservers<K extends ObservableSubscriber>() {
    return _secretary.values();
    return null;
  }

  @override
  String getPassport() {
    return getName();
  }

  @override
  void onChange<T>(T object) {
    for (ObservableSubscriber subscriber in _secretary.values()) {
      if (subscriber.validate()) {
        subscriber.onChange(object);
      }
    }
  }

  @override
  void removeObserver<K extends ObservableSubscriber>(K subscriber) {
    if (subscriber == null) return;

    if (_secretary.containsKey(subscriber.getName())) {
      if (subscriber == _secretary.get(subscriber.getName())) {
        _secretary.remove(subscriber.getName());
      }

      if (_secretary.isEmpty()) {
        unregister();
      }
    }
  }
}
