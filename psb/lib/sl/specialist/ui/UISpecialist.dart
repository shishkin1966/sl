import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:psb/sl/Specialist.dart';
import 'package:psb/sl/action/Action.dart';

abstract class UISpecialist extends Specialist {
  void showToast(String text);

  void showErrorToast(String text);

  SnackBar getSnackBar(String text, {Duration duration, String actionText, Action action});

  SnackBar getNoConnectivitySnackBar(String text);

  Flushbar getFlushbar(
    String text, {
    String title,
    Duration duration,
    flushbarPosition,
    backgroundColor,
    icon,
    bool isDismissible,
  });
}
