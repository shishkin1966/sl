import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/specialist/finger/FingerPrintSpecialist.dart';

class FingerprintSpecialistImpl extends AbsSpecialist implements FingerprintSpecialist {
  static const String NAME = "FingerprintSpecialistImpl";

  LocalAuthentication _localAuth;

  @override
  void onRegister() {
    _localAuth = LocalAuthentication();
  }

  @override
  int compareTo(other) {
    return (other is FingerprintSpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  Future<bool> hasBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

    /*
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
      }
    }
    */
    return availableBiometrics;
  }

  @override
  Future<Result> authenticateWithBiometrics({String localizedReason, bool useErrorDialogs, bool stickyAuth}) async {
    bool authenticate = false;
    Result result = new Result(authenticate);
    try {
      authenticate = await _localAuth.authenticateWithBiometrics(
          localizedReason: localizedReason, stickyAuth: stickyAuth, useErrorDialogs: useErrorDialogs);
      result.setData(authenticate);
    } on PlatformException catch (e) {
      result.setData(false).addError(NAME, e.code);
    }
    return result;
  }
}
