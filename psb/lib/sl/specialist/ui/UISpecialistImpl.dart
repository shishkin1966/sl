import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/message/ActionMessage.dart';
import 'package:psb/sl/specialist/ui/UISpecialist.dart';
import 'package:psb/ui/Application.dart';

class UISpecialistImpl extends AbsSpecialist implements UISpecialist {
  static const String NAME = "UISpecialistImpl";

  @override
  int compareTo(other) {
    return (other is UISpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void showErrorToast(String text) {
    if (StringUtils.isNullOrEmpty(text)) return;

    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  void showToast(String text) {
    if (StringUtils.isNullOrEmpty(text)) return;

    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Colors.black87,
        textColor: Colors.white);
  }

  @override
  SnackBar getSnackBar(String text,
      {Duration duration = const Duration(seconds: 4), String actionText, Action action}) {
    if (StringUtils.isNullOrEmpty(actionText)) {
      return new SnackBar(
        backgroundColor: Color(0xff404040),
        duration: duration,
        content: Text(text),
      );
    } else {
      return new SnackBar(
        backgroundColor: Color(0xff404040),
        duration: duration,
        content: Text(text),
        action: SnackBarAction(
          label: actionText,
          onPressed: () {
            SLUtil.addMessage(new ActionMessage.action(Application.NAME, action));
          },
        ),
      );
    }
  }

  @override
  SnackBar getNoConnectivitySnackBar(String text) {
    return new SnackBar(
      backgroundColor: Color(0xffff5514),
      duration: new Duration(days: 1),
      content: Text(text),
    );
  }

  @override
  Flushbar getFlushbar(String text,
      {String title,
      Duration duration,
      flushbarPosition = FlushbarPosition.TOP,
      backgroundColor = const Color(0xff404040),
      icon,
      dismissDirection = FlushbarDismissDirection.HORIZONTAL,
      bool isDismissible = true}) {
    return new Flushbar(
      message: text,
      isDismissible: isDismissible,
      title: title,
      duration: duration,
      flushbarPosition: flushbarPosition,
      backgroundColor: backgroundColor,
      icon: icon,
    );
  }

  @override
  Flushbar getErrorFlushbar(String text, {String title}) {
    return new Flushbar(
      message: text,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      title: title,
      duration: new Duration(seconds: 8),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Color(0xffff5514),
      icon: new SvgPicture.asset(
        "assets/vector/ic_error.svg",
      ),
    );
  }
}
