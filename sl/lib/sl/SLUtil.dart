import 'package:sl/sl/SL.dart';
import 'package:sl/sl/observe/ObjectObservable.dart';
import 'package:sl/sl/specialist/messager/MessengerUnion.dart';
import 'package:sl/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:sl/sl/specialist/observable/ObservableUnion.dart';
import 'package:sl/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnion.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';

class SLUtil {
  static PresenterUnion getPresenterUnion() {
    return SL.instance.get(PresenterUnionImpl.NAME);
  }

  static MessengerUnion getMessengerUnion() {
    return SL.instance.get(MessengerUnionImpl.NAME);
  }

  static ObservableUnion getObservableUnion() {
    return SL.instance.get(ObservableUnionImpl.NAME);
  }

  static void onChange(String object) {
    final ObjectObservable observable = getObservableUnion().getObservable(ObjectObservable.NAME);
    if (observable != null) {
      observable.onChange(object);
    }
  }
}
