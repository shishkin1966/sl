import 'package:sl/sl/AbsSmallUnion.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/Union.dart';

abstract class AbsUnion<T extends SpecialistSubscriber> extends AbsSmallUnion<T> implements Union<T> {
  var _currentSubscriber;

  @override
  bool registerSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) return false;

    if (super.registerSubscriber(subscriber)) {
      if (_currentSubscriber != null) {
        if (subscriber.name == _currentSubscriber.name) {
          _currentSubscriber = subscriber;
        }
      }
      return true;
    }
    return false;
  }

  @override
  void unregisterSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) return;

    super.unregisterSubscriber(subscriber);

    if (_currentSubscriber != null) {
      if (subscriber.name == _currentSubscriber.name) {
        if (_currentSubscriber == subscriber) {
          _currentSubscriber = null;
        }
      }
    }
  }

  @override
  void setCurrentSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) return;

    if (!checkSubscriber(subscriber)) return;

    _currentSubscriber = subscriber;
  }
}
