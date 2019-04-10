import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/action/Action.dart';

abstract class UISpecialist extends AbsSpecialist {
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

  Flushbar getErrorFlushbar(String text);

  void hideKeyboard(BuildContext context);

  void showKeyboard(BuildContext context, FocusNode focusNode);
}
