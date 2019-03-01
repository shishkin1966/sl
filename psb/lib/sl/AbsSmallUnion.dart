import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/Secretary.dart';
import 'package:psb/sl/SecretaryImpl.dart';
import 'package:psb/sl/SmallUnion.dart';
import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/state/Stateable.dart';
import 'package:psb/sl/state/States.dart';

abstract class AbsSmallUnion<T extends SpecialistSubscriber> extends AbsSpecialist implements SmallUnion<T> {
  static const String NAME = "AbsSmallUnion";

  Secretary _secretary;

  AbsSmallUnion() {
    _secretary = createSecretary();
  }

  @override
  Secretary<T> createSecretary<T>() {
    return new SecretaryImpl<T>();
  }

  @override
  void onAddSubscriber<T>(T subscriber) {}

  @override
  void onUnRegisterLastSubscriber() {}

  @override
  void onRegisterFirstSubscriber() {}

  @override
  T getSubscriber<T>(String name) {
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
  List<T> getReadySubscribers<T>() {
    final List<T> subscribers = new List<T>();
    for (T subscriber in getSubscribers()) {
      if (subscriber != null && (subscriber as SpecialistSubscriber).validate()) {
        if (subscriber is Stateable) {
          if (subscriber.getState() == States.StateReady) {
            subscribers.add(subscriber);
          }
        }
      }
    }
    return subscribers;
  }

  @override
  List<T> getValidatedSubscribers<T>() {
    final List<T> subscribers = new List<T>();
    for (T subscriber in getSubscribers()) {
      if (subscriber != null && (subscriber as SpecialistSubscriber).validate()) {
        subscribers.add(subscriber);
      }
    }
    return subscribers;
  }

  @override
  List<T> getSubscribers<T>() {
    return _secretary.values();
  }

  @override
  void unregisterByName(String name) {
    if (hasSubscriber(name)) {
      unregisterSubscriber(getSubscriber(name));
    }
  }

  @override
  void unregisterSubscriber<T>(T subscriber) {
    if (subscriber == null) {
      return;
    }

    final int cnt = _secretary.size();
    if (_secretary.containsKey((subscriber as SpecialistSubscriber).getName())) {
      if (subscriber == _secretary.get((subscriber as SpecialistSubscriber).getName())) {
        _secretary.remove((subscriber as SpecialistSubscriber).getName());
      }
    }

    if (cnt == 1 && _secretary.size() == 0) {
      onUnRegisterLastSubscriber();
    }
  }

  @override
  bool registerSubscriber<T>(T subscriber) {
    if (subscriber == null) {
      return false;
    }

    if (!checkSubscriber(subscriber)) {
      ErrorSpecialistImpl.instance.onErrorMessage(NAME, "Suscriber is not authenticated : " + subscriber.toString());
      return false;
    }

    if (!(subscriber as SpecialistSubscriber).validate()) {
      ErrorSpecialistImpl.instance.onErrorMessage(NAME, "Registration not valid subscriber: " + subscriber.toString());
      return false;
    }

    final int cnt = _secretary.size();

    _secretary.put((subscriber as SpecialistSubscriber).getName(), subscriber);

    if (cnt == 0 && _secretary.size() == 1) {
      onRegisterFirstSubscriber();
    }
    onAddSubscriber(subscriber as SpecialistSubscriber);
    return true;
  }

  @override
  bool checkSubscriber<T>(T subscriber) {
    return !StringUtils.isNullOrEmpty((subscriber as SpecialistSubscriber).getPassport()) &&
        !StringUtils.isNullOrEmpty((subscriber as SpecialistSubscriber).getName());
  }
}
