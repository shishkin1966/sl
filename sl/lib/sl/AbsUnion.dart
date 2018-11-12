import 'package:sl/sl/AbsSmallUnion.dart';
import 'package:sl/sl/SpecialistSubscriber.dart';
import 'package:sl/sl/Union.dart';

abstract class AbsUnion<T extends SpecialistSubscriber> extends AbsSmallUnion<T>
    implements Union<T> {
  var currentSubscriber;

  @override
  bool registerSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) return false;

    if (super.registerSubscriber(subscriber)) {
      if (currentSubscriber != null) {
        if (subscriber.name == currentSubscriber.name) {
          currentSubscriber = subscriber;
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

    if (currentSubscriber != null) {
      if (subscriber.name == currentSubscriber.name) {
        if (currentSubscriber == subscriber) {
          currentSubscriber = null;
        }
      }
    }
  }

  @override
  void setCurrentSubscriber<T extends SpecialistSubscriber>(T subscriber) {
    if (subscriber == null) return;

    if (!checkSubscriber(subscriber)) return;

    currentSubscriber = subscriber;
  }
}
