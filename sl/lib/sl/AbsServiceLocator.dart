import 'package:sl/sl/SecretaryImpl.dart';
import 'package:sl/sl/ServiceLocator.dart';
import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/Specialist.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/Union.dart';
import 'package:sl/sl/util/StringUtils.dart';

abstract class AbsServiceLocator implements ServiceLocator {
  var secretary = new SecretaryImpl<Specialist>();

  @override
  T get<T extends Specialist>(final String name) {
    if (!exists(name)) {
      if (!registerSpecialistByName(name)) {
        return null;
      }
    }

    if (secretary.containsKey(name)) {
      return secretary.get(name) as T;
    }
    return null;
  }

  @override
  bool exists(final String name) {
    if (StringUtils.isNullOrEmpty(name)) {
      return false;
    }

    return secretary.containsKey(name);
  }

  @override
  bool registerSpecialist(final Specialist specialist) {
    if (specialist != null && !StringUtils.isNullOrEmpty(specialist.name)) {
      if (secretary.containsKey(specialist.name)) {
        if (!unregisterSpecialist(specialist.name)) {
          return false;
        }
      }

      secretary.put(specialist.name, specialist);
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
      if (secretary.containsKey(name)) {
        final Specialist specialist = secretary.get(name);
        if (specialist != null) {
          if (!specialist.isPersistent()) {
            // нельзя отменить подписку у объединения с подписчиками
            if (specialist is SmallUnion) {
              if (specialist.hasSubscribers()) {
                return false;
              }
            }
            specialist.onUnRegister();
            secretary.remove(name);
          }
        } else {
          secretary.remove(name);
        }
      }
    }
    return true;
  }

  @override
  bool registerSubscriber(final SpecialistSubscriber subscriber) {
    if (subscriber != null && !StringUtils.isNullOrEmpty(subscriber.name)) {
      final List<String> types = subscriber.getSpecialistSubscription();
      if (types != null) {
        // регистрируемся subscriber у специалистов
        for (String specialistName in types) {
          if (!StringUtils.isNullOrEmpty(specialistName)) {
            if (secretary.containsKey(specialistName)) {
              (secretary.get(specialistName) as SmallUnion).registerSubscriber(subscriber);
            } else {
              registerSpecialistByName(specialistName);
              if (secretary.containsKey(specialistName)) {
                (secretary.get(specialistName) as SmallUnion).registerSubscriber(subscriber);
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
        for (Specialist specialist in secretary.values()) {
          if (specialist is SmallUnion) {
            final String specialistName = specialist.name;
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
        for (Specialist specialist in secretary.values()) {
          if (specialist is Union) {
            final String specialistName = specialist.name;
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
    return secretary.values();
  }
}
