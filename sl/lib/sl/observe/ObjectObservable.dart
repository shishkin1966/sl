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
  static const int DURATION = 5000;

  Secretary<List<String>> _objects = new SecretaryImpl();
  Secretary<InterruptByTime> _timers = new SecretaryImpl();
  Secretary<int> _durations = new SecretaryImpl();

  @override
  String getName() {
    return NAME;
  }

  @override
  void register() {}

  @override
  void unregister() {}

  void setDuration(final String object, final int duration) {
    if (StringUtils.isNullOrEmpty(object)) return;

    _durations.put(object, duration);
  }

  @override
  void addObserver<T extends ObservableSubscriber>(T subscriber) {
    if (subscriber == null) return;

    super.addObserver(subscriber);

    if (subscriber is ObjectObservableSubscriber) {
      final List<String> list = subscriber.getListenObjects();
      final String name = subscriber.getName();
      int duration = DURATION;

      for (String listenObject in list) {
        if (!_objects.containsKey(listenObject)) {
          if (_durations.containsKey(listenObject)) {
            duration = _durations.get(listenObject);
          }

          _objects.put(listenObject, new List());
          _timers.put(listenObject, new InterruptByTime(this, listenObject, duration));
        }
        if (!_objects.get(listenObject).contains(name)) {
          _objects.get(listenObject).add(name);
        }
      }
    }
  }

  @override
  void removeObserver<T extends ObservableSubscriber>(T subscriber) {
    if (subscriber == null) return;

    if (subscriber is ObjectObservableSubscriber) {
      for (List<String> observers in _objects.values()) {
        if (observers.contains(subscriber.getName())) {
          observers.remove(subscriber.getName());
        }
      }
      final List<String> deleted = new List();
      for (String object in _objects.keys()) {
        if (_objects.get(object).isEmpty) {
          deleted.add(object);
          _timers.get(object).cancel();
          _timers.remove(object);
        }
      }
      for (String object in deleted) {
        if (_objects.containsKey(object)) {
          _objects.remove(object);
        }
      }
    }

    super.removeObserver(subscriber);
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
