import 'package:flutter/material.dart';

class AccountInheritedWidget extends InheritedWidget {
  AccountInheritedWidget({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(AccountInheritedWidget old) {
    return true;
  }
}
