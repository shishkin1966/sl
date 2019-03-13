import 'package:flutter/services.dart';
import 'package:psb/sl/SLUtil.dart';

class Secure {
  static const String NAME = "Secure";
  static const _channel = MethodChannel("flutter.shishkin.psb/secure");

  Future<String> encode(String value) async {
    String result;
    try {
      result = await _channel.invokeMethod('encode', value);
    } on PlatformException catch (e) {
      SLUtil.onError(NAME, e);
    }
    return result;
  }

  Future<String> decode(String value) async {
    String result;
    try {
      result = await _channel.invokeMethod('decode', value);
    } on PlatformException catch (e) {
      SLUtil.onError(NAME, e);
    }
    return result;
  }
}
