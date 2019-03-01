import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/SecretaryImpl.dart';
import 'package:psb/sl/ServiceLocator.dart';
import 'package:psb/sl/SmallUnion.dart';
import 'package:psb/sl/Specialist.dart';
import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/Union.dart';

abstract class AbsServiceLocator implements ServiceLocator {
  var _secretary = new SecretaryImpl<Specialist>();

  @override
  T get<T extends Specialist>(final String name) {
    if (!exists(name)) {
      if (!registerSpecialistByName(name)) {
        return null;
      }
    }

    if (_secretary.containsKey(name)) {
      return _secretary.get(name) as T;
    }
    return null;
  }

  @override
  bool exists(final String name) {
    if (StringUtils.isNullOrEmpty(name)) {
      return false;
    }

    return _secretary.containsKey(name);
  }

  @override
  bool registerSpecialist(final Specialist specialist) {
    if (specialist != null && !StringUtils.isNullOrEmpty(specialist.getName())) {
      if (_secretary.containsKey(specialist.getName())) {
        if (!unregisterSpecialist(specialist.getName())) {
          return false;
        }
      }

      _secretary.put(specialist.getName(), specialist);
      specialist.onRegister();
    }
    return true;
  }

  @override
  bool registerSpecialistByName(final String name) {
    final Specialist specialist = getSpecialistFactory().create(name);
    if (specialist != null) {
      return registerSpecialist(specialist);
    }
    return false;
  }

  @override
  bool unregisterSpecialist(final String name) {
    if (!StringUtils.isNullOrEmpty(name)) {
      if (_secretary.containsKey(name)) {
        final Specialist specialist = _secretary.get(name);
        if (specialist != null) {
          if (!specialist.isPersistent()) {
            // нельзя отменить подписку у объединения с подписчиками
            if (specialist is SmallUnion) {
              if (specialist.hasSubscribers()) {
                return false;
              }
            }
            specialist.onUnRegister();
            _secretary.remove(name);
          }
        } else {
          _secretary.remove(name);
        }
      }
    }
    return true;
  }

  @override
  bool registerSubscriber(final SpecialistSubscriber subscriber) {
    if (subscriber != null && !StringUtils.isNullOrEmpty(subscriber.getName())) {
      final List<String> types = subscriber.getSpecialistSubscription();
      if (types != null) {
        // регистрируемся subscriber у специалистов
        for (String specialistName in types) {
          if (!StringUtils.isNullOrEmpty(specialistName)) {
            if (_secretary.containsKey(specialistName)) {
              (_secretary.get(specialistName) as SmallUnion).registerSubscriber(subscriber);
            } else {
              registerSpecialistByName(specialistName);
              if (_secretary.containsKey(specialistName)) {
                (_secretary.get(specialistName) as SmallUnion).registerSubscriber(subscriber);
              } else {
                return false;
              }
            }
          }
        }
      }
    }
    return true;
  }

  @override
  bool unregisterSubscriber(final SpecialistSubscriber subscriber) {
    if (subscriber != null) {
      final List<String> types = subscriber.getSpecialistSubscription();
      if (types != null) {
        for (Specialist specialist in _secretary.values()) {
          if (specialist is SmallUnion) {
            final String specialistName = specialist.getName();
            if (!StringUtils.isNullOrEmpty(specialistName) && types.contains(specialistName)) {
              specialist.unregisterSubscriber(subscriber);
            }
          }
        }
      }
    }
    return true;
  }

  @override
  bool setCurrentSubscriber(final SpecialistSubscriber subscriber) {
    if (subscriber != null) {
      final List<String> types = subscriber.getSpecialistSubscription();
      if (types != null) {
        for (Specialist specialist in _secretary.values()) {
          if (specialist is Union) {
            final String specialistName = specialist.getName();
            if (!StringUtils.isNullOrEmpty(specialistName)) {
              if (types.contains(specialistName)) {
                specialist.setCurrentSubscriber(subscriber);
              }
            }
          }
        }
      }
    }
    return true;
  }

  @override
  List<Specialist> getSpecialists() {
    return _secretary.values();
  }
}
