import 'package:local_auth/local_auth.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/data/Result.dart';

abstract class FingerprintSpecialist extends AbsSpecialist {
  Future<bool> hasBiometrics();

  Future<List<BiometricType>> getAvailableBiometrics();

  Future<Result> authenticateWithBiometrics(String localizedReason, {bool useErrorDialogs, bool stickyAuth});
}
