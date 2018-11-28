import 'package:flutter/material.dart';
import 'package:sl/app/screen/home/HomeScreenPresenter.dart';
import 'package:sl/app/screen/second/SecondScreen.dart';
import 'package:sl/app/screen/second/SecondScreenPresenter.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/action/ApplicationAction.dart';
import 'package:sl/sl/action/DataAction.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

class SecondScreenState extends LifecycleWidgetState<SecondScreen> {
  String _title = "Экран 2";

  SecondScreenState() : super();

  @override
  void onAction(final Action action) {
    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case SecondScreenPresenter.OnChangeObject:
          _title = action.getData().title;
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: (() {
            getPresenter().addAction(new ApplicationAction(HomeScreenPresenter.Increment));
          }),
          child: new Icon(Icons.add)),
      bottomSheet: new Container(
        width: double.infinity,
        height: 56,
        color: Colors.deepOrange,
        child: MaterialButton(
          onPressed: () {
            getPresenter().addAction(new ApplicationAction(Actions.OnPressed));
          },
          child: new Text(
            "Назад",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Presenter<LifecycleWidgetState<StatefulWidget>> createPresenter() {
    return new SecondScreenPresenter(this);
  }
}
