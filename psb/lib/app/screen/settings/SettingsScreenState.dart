import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/screen/settings/SettingsScreenPresenter.dart';
import 'package:psb/app/screen/settings/SettingsScreenWidget.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';

class SettingsScreenState extends WidgetState<SettingsScreenWidget> {
  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new SettingsScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: new Scaffold(
        key: getKey(),
        backgroundColor: Color(0xfff0f0ff),
        body: new Builder(builder: (BuildContext context) {
          widgetContext = context;
          return SafeArea(top: true, child: _getWidget());
        }),
      ),
    );
  }

  Widget _getWidget() {
    return new Stack(
      children: [],
    );
  }
}
