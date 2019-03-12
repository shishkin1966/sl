import 'package:flutter/material.dart';
import 'package:psb/sl/Specialist.dart';
import 'package:psb/sl/action/Action.dart';

abstract class UISpecialist extends Specialist {
  void showToast(String text);

  void showErrorToast(String text);

  SnackBar getSnackBar(String text, Duration duration);

  SnackBar getSnackBarWithAction(String text, Duration duration, String actionText, Action action);

  SnackBar getNoConnectivitySnackBar(String text);
}
