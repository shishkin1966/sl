import 'package:flutter/services.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/specialist/secure/SecureSpecialist.dart';

class SecureSpecialistImpl extends AbsSpecialist implements SecureSpecialist {
  static const String NAME = "SecureSpecialistImpl";

  MethodChannel _channel;

  @override
  void onRegister() {
    _channel = MethodChannel("flutter.shishkin.psb/secure");
  }

  @override
  int compareTo(other) {
    return (other is SecureSpecialist) ? 0 : 1;
  }

  @override
  Future<String> decode(String value) async {
    String result;
    try {
      result = await _channel.invokeMethod('decode', value);
    } on PlatformException catch (e) {
      ErrorSpecialistImpl.instance.onError(NAME, e);
    }
    return result;
  }

  @override
  Future<String> encode(String value) async {
    String result;
    try {
      result = await _channel.invokeMethod('encode', value);
    } on PlatformException catch (e) {
      ErrorSpecialistImpl.instance.onError(NAME, e);
    }
    return result;
  }

  @override
  String getName() {
    return NAME;
  }
}
