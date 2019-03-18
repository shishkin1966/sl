import 'package:flutter/material.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/router/RouterSpecialist.dart';

class RouterSpecialistImpl extends AbsSpecialist implements RouterSpecialist {
  static const String NAME = "RouterSpecialistImpl";

  @override
  void showScreen(BuildContext context, String screen) {
    Navigator.of(context).pushNamed(screen);
  }

  @override
  void showScreenAndRemoveUntil(BuildContext context, String screen) {
    Navigator.of(context).pushNamedAndRemoveUntil(screen, (Route<dynamic> route) => false);
  }

  @override
  void removeScreenUntil(BuildContext context, String screen) {
    Navigator.popUntil(context, ModalRoute.withName(screen));
  }

  @override
  void showOperationScreen(BuildContext context, Operation operation) {
//    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new OperationScreen(operation)));
  }

  @override
  int compareTo(other) {
    return (other is RouterSpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }
}
