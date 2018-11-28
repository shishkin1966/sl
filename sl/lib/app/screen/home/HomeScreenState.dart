import 'package:flutter/material.dart';
import 'package:sl/app/screen/home/HomeScreen.dart';
import 'package:sl/app/screen/home/HomeScreenData.dart';
import 'package:sl/app/screen/home/HomeScreenPresenter.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/action/ApplicationAction.dart';
import 'package:sl/sl/action/DataAction.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

class HomeScreenState extends LifecycleWidgetState<HomeScreen> {
  String _title = States.StateCreate;
  HomeScreenData _data = new HomeScreenData();

  HomeScreenState() : super();

  @override
  void onAction(final Action action) {
    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case HomeScreenPresenter.Increment:
          _data.counter += action.getData().counter;
          break;

        case HomeScreenPresenter.Response:
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
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              _data.counter.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      bottomSheet: new Container(
        width: double.infinity,
        height: 56,
        color: Colors.deepOrange,
        child: MaterialButton(
          onPressed: () {
            getPresenter().addAction(new ApplicationAction(Actions.OnPressed));
          },
          child: new Text(
            "Вперед",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (() {
          HomeScreenData data = new HomeScreenData();
          data.counter = 2;
          getPresenter().addAction(new DataAction<HomeScreenData>(HomeScreenPresenter.Increment).setData(data));
        }),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  @override
  Presenter<LifecycleWidgetState<StatefulWidget>> createPresenter() {
    return new HomeScreenPresenter(this);
  }
}
