import 'package:sl/common/StringUtils.dart';
import 'package:sl/sl/AbsSpecialist.dart';
import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/SecretaryImpl.dart';
import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/state/Stateable.dart';
import 'package:sl/sl/state/States.dart';

abstract class AbsSmallUnion<T extends SpecialistSubscriber> extends AbsSpecialist implements SmallUnion<T> {
  var _secretary;

  AbsSmallUnion() {
    _secretary = createSecretary();
  }

  @override
  Secretary<T> createSecretary<T extends SpecialistSubscriber>() {
    return new SecretaryImpl<T>();
  }

  @override
  void onAddSubscriber(T subscriber) {}

  @override
  void onUnRegisterLastSubscriber() {}

  @override
  void onRegisterFirstSubscriber() {}

  @override
  T getSubscriber<T extends SpecialistSubscriber>(String name) {
    if (StringUtils.isNullOrEmpty(name)) return null;

    if (!_secretary.containsKey(name)) {
      return null;
    }

    return _secretary.get(name);
  }

  @override
  bool hasSubscriber(String name) {
    return _secretary.containsKey(name);
  }

  @override
  bool hasSubscribers() {
    return (!_secretary.isEmpty());
  }

  @override
  List<T> getReadySubscribers<T extends SpecialistSubscriber>() {
    final List<T> subscribers = new List<T>();
    for (T subscriber in getSubscribers()) {
      if (subscriber != null && subscriber.validate()) {
        if (subscriber is Stateable) {
          final Stateable stateable = subscriber as Stateable;
          if (stateable.getState() == States.StateReady) {
            subscribers.add(subscriber);
          }
        }
      }
    }
    return subscribers;
  }

  @override
  List<T> getValidatedSubscribers<T extends SpecialistSubscriber>() {
    final List<T> subscribers = new List<T>();
    for (T subscriber in getSubscribers()) {
      if (subscriber != null && subscriber.validate()) {
        subscribers.add(subscriber);
      }
    }
    return subscribers;
  }

  @override
  List<T> getSubscribers<T extends SpecialistSubscriber>() {
    return _secretary.values();
  }

  @override
  void unregisterByName(String name) {
    if (hasSubscriber(name)) {
      unregisterSubscriber(getSubscriber(name));
    }
  }

  @override
  void unregisterSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) {
      return;
    }

    final int cnt = _secretary.size();
    if (_secretary.containsKey(subscriber.getName())) {
      if (subscriber == _secretary.get(subscriber.getName())) {
        _secretary.remove(subscriber.getName());
      }
    }

    if (cnt == 1 && _secretary.size() == 0) {
      onUnRegisterLastSubscriber();
    }
  }

  @override
  bool registerSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) {
      return false;
    }

    if (!checkSubscriber(subscriber)) {
      //ErrorSpecialistImpl.getInstance().onError(NAME,
      //    "Suscriber is not authenticated : " + subscriber.toString(), true);
      return false;
    }

    if (!subscriber.validate()) {
      //ErrorSpecialistImpl.getInstance().onError(NAME,
      //    "Registration not valid subscriber: " + subscriber.toString(), true);
      return false;
    }

    final int cnt = _secretary.size();

    _secretary.put(subscriber.getName(), subscriber);

    if (cnt == 0 && _secretary.size() == 1) {
      onRegisterFirstSubscriber();
    }
    onAddSubscriber(subscriber as SpecialistSubscriber);
    return true;
  }

  @override
  bool checkSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    return !StringUtils.isNullOrEmpty(subscriber.getPasport()) && !StringUtils.isNullOrEmpty(subscriber.getName());
  }
}
