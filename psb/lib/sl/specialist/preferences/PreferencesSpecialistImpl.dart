import 'dart:async';

import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesSpecialistImpl extends AbsSpecialist implements PreferencesSpecialist {
  static const String NAME = "PreferencesSpecialistImpl";

  @override
  int compareTo(other) {
    return (other is PreferencesSpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  Future<SharedPreferences> get() async {
    return SharedPreferences.getInstance();
  }

  @override
  void setInt(String name, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(name, value);
  }

  @override
  void setString(String name, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, value);
  }

  @override
  void setBool(String name, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, value);
  }

  @override
  void setDouble(String name, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(name, value);
  }

  @override
  void setStringList(String name, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(name, value);
  }

  /*
  @override
  int getInt(String name) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(name);
  }
  */
}
