import 'package:psb/sl/AbsSmallUnion.dart';
import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/Union.dart';

abstract class AbsUnion<T extends SpecialistSubscriber> extends AbsSmallUnion<T> implements Union<T> {
  SpecialistSubscriber _currentSubscriber;

  @override
  bool registerSubscriber<T>(T subscriber) {
    if (subscriber == null) return false;

    if (super.registerSubscriber(subscriber)) {
      if (_currentSubscriber != null) {
        if ((subscriber as SpecialistSubscriber).getName() == _currentSubscriber.getName()) {
          _currentSubscriber = subscriber as SpecialistSubscriber;
        }
      }
      return true;
    }
    return false;
  }

  @override
  void unregisterSubscriber<T>(T subscriber) {
    if (subscriber == null) return;

    super.unregisterSubscriber(subscriber);

    if (_currentSubscriber != null) {
      if ((subscriber as SpecialistSubscriber).getName() == _currentSubscriber.getName()) {
        if (_currentSubscriber == subscriber) {
          _currentSubscriber = null;
        }
      }
    }
  }

  @override
  void setCurrentSubscriber<T>(T subscriber) {
    if (subscriber == null) return;

    if (!checkSubscriber(subscriber)) return;

    _currentSubscriber = subscriber as SpecialistSubscriber;
  }
}
