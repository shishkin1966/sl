import 'package:sl/common/InterruptByTime.dart';
import 'package:sl/common/InterruptListener.dart';
import 'package:sl/common/StringUtils.dart';
import 'package:sl/sl/SL.dart';
import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/SecretaryImpl.dart';
import 'package:sl/sl/observe/AbsObservable.dart';
import 'package:sl/sl/observe/ObjectObservableSubscriber.dart';
import 'package:sl/sl/specialist/observable/ObservableSubscriber.dart';
import 'package:sl/sl/specialist/observable/ObservableUnion.dart';
import 'package:sl/sl/specialist/observable/ObservableUnionImpl.dart';

class ObjectObservable extends AbsObservable<ObjectObservableSubscriber> implements InterruptListener {
  static const String NAME = "ObjectObservable";

  Secretary<List<String>> _objects = new SecretaryImpl();
  Secretary<InterruptByTime> _timers = new SecretaryImpl();

  @override
  String getName() {
    return NAME;
  }

  @override
  void register() {}

  @override
  void unregister() {}

  @override
  void addObserver<T extends ObservableSubscriber>(T subscriber) {
    if (subscriber == null) return;

    super.addObserver(subscriber);

    if (subscriber is ObjectObservableSubscriber) {
      final List<String> list = subscriber.getListenObjects();

      for (String listenObject in list) {
        if (!_objects.containsKey(listenObject)) {
          _objects.put(listenObject, new List());
          _timers.put(listenObject, new InterruptByTime(this, listenObject));
        }
        if (!_objects.get(listenObject).contains(subscriber.getName())) {
          _objects.get(listenObject).add(subscriber.getName());
        }
      }
    }
  }

  @override
  void removeObserver<T extends ObservableSubscriber>(T subscriber) {
    if (subscriber == null) return;

    super.removeObserver(subscriber);

    if (subscriber is ObjectObservableSubscriber) {
      for (List<String> observers in _objects.values()) {
        if (observers.contains(subscriber.getName())) {
          observers.remove(subscriber.getName());
        }
      }
      for (String object in _objects.keys()) {
        if (_objects.get(object).isEmpty) {
          _objects.remove(object);
          _timers.get(object).cancel();
          _timers.remove(object);
        }
      }
    }
  }

  @override
  void onChange<T>(T object) {
    if (object == null) return;
    final String name = object as String;
    if (StringUtils.isNullOrEmpty(name)) return;

    _timers.get(name).up();
  }

  void onChangeAll() {
    for (String object in _objects.keys()) {
      final List<String> subscribers = _objects.get(object);
      final ObservableUnion _union = SL.instance.get(ObservableUnionImpl.NAME);
      if (_union != null) {
        for (String name in subscribers) {
          final ObservableSubscriber observableSubscriber = _union.getSubscriber(name);
          if (observableSubscriber != null && observableSubscriber.validate()) {
            observableSubscriber.onChange(object);
          }
        }
      }
    }
  }

  @override
  void onInterrupt(String listenObject) {
    final List<String> listSubscibers = _objects.get(listenObject);
    final ObservableUnion _union = SL.instance.get(ObservableUnionImpl.NAME);
    if (_union != null) {
      for (String name in listSubscibers) {
        final ObservableSubscriber subscriber = _union.getSubscriber(name);
        if (subscriber != null && subscriber.validate()) {
          subscriber.onChange(listenObject);
        }
      }
    }
  }
}
