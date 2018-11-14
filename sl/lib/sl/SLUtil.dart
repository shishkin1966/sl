import 'package:sl/sl/SL.dart';
import 'package:sl/sl/specialist/messager/MessagerUnion.dart';
import 'package:sl/sl/specialist/messager/MessagerUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnion.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';

class SLUtil {
  static PresenterUnion getPresenterUnion() {
    return SL.instance.get(PresenterUnionImpl.NAME);
  }

  static MessagerUnion getMessagerUnion() {
    return SL.instance.get(MessagerUnionImpl.NAME);
  }
}
