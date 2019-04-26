import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/screen/accounts/AccountsScreenPresenter.dart';
import 'package:psb/app/screen/accounts/AccountsScreenWidget.dart';
import 'package:psb/res/AppColor.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AccountsScreenState extends WidgetState<AccountsScreenWidget> {
  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new AccountsScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: new Scaffold(
        key: getScaffoldKey(),
        backgroundColor: Colors.transparent,
        body: new Builder(builder: (BuildContext context) {
          return SafeArea(
            top: true,
            child: _getWidget(),
          );
        }),
      ),
    );
  }

  Widget _getWidget() {
    return new Stack(
      children: [
        new Container(
          color: Color(AppColor.Background),
        ),
      ],
    );
  }
}
