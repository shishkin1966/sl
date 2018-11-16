import 'package:flutter/material.dart';
import 'package:sl/app/screen/home/HomeChangeState.dart';
import 'package:sl/app/screen/home/HomeScreenPresenter.dart';
import 'package:sl/app/screen/second/SecondScreen.dart';
import 'package:sl/app/screen/second/SecondScreenPresenter.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

class SecondScreenState extends LifecycleWidgetState<SecondScreen> {
  String _title = "Экран 2";

  SecondScreenState() : super();

  @override
  void onAction(final Action action) {
    switch (action.getName()) {
      case SecondScreenPresenter.OnChangeObject:
        _title = (action.getValue() as HomeChangeState).title;
        break;
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
            getPresenter().doOrder(HomeScreenPresenter.Increment, null);
          }),
          child: new Icon(Icons.add)),
      bottomSheet: new Container(
        width: double.infinity,
        height: 56,
        color: Colors.deepOrange,
        child: MaterialButton(
          onPressed: () {
            getPresenter().doOrder(Actions.OnPressed, null);
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
