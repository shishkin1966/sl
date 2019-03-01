import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialist.dart';

class DesktopSpecialistImpl extends AbsSpecialist implements DesktopSpecialist {
  static const String NAME = "DesktopSpecialistImpl";

  @override
  String getDesktop() {
    return "Default";
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  int compareTo(other) {
    return (other is DesktopSpecialist) ? 0 : 1;
  }
}
