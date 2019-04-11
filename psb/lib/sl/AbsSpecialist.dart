import 'package:psb/sl/Specialist.dart';
import 'package:psb/sl/data/Result.dart';

abstract class AbsSpecialist implements Specialist {
  @override
  void onUnRegister() {}

  @override
  void onRegister() {}

  @override
  bool isPersistent() {
    return false;
  }

  @override
  Result<bool> validateExt() {
    return new Result<bool>(true);
  }

  @override
  bool validate() {
    return validateExt().getData();
  }

  @override
  void stop() {}

  @override
  void clear() {}

  @override
  String getPassport() {
    return this.getName();
  }
}
