import 'package:flutter/material.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/sl/Specialist.dart';

abstract class RouterSpecialist extends Specialist {
  void showScreen(BuildContext context, String screen);

  void showScreenAndRemoveUntil(BuildContext context, String screen);

  void removeScreenUntil(BuildContext context, String screen);

  void showOperationScreen(BuildContext context, Operation operation);

  void showWidget(BuildContext context, WidgetBuilder builder);

  Future showWidgetWithResult(BuildContext context, WidgetBuilder builder);
}
