import 'package:flutter/material.dart';
import 'package:sl/app/screen/home/HomeScreen.dart';
import 'package:sl/app/screen/home/HomeScreenPresenter.dart';
import 'package:sl/app/screen/home/HomeViewData.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/ui/LifecycleState.dart';

class HomeScreenState extends LifecycleState<HomeScreen> {
  String _title = States.StateCreate;
  HomeViewData _data = new HomeViewData();

  HomeScreenState() : super();

  @override
  void onAction(final Action action) {
    switch (action.getName()) {
      case HomeScreenPresenenter.Increment:
        _data.counter += (action.getValue() as HomeViewData).counter;
        break;

      case HomeScreenPresenenter.Response:
        _title = (action.getValue() as HomeViewData).title;
        break;
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
            getPresenter().doOrder(Actions.OnPressed, null);
          },
          child: new Text(
            "Вперед",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (() {
          HomeViewData viewData = new HomeViewData();
          viewData.counter = 2;
          getPresenter().doOrder(HomeScreenPresenenter.Increment, viewData);
        }),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  @override
  Presenter<LifecycleState<StatefulWidget>> createPresenter() {
    return new HomeScreenPresenenter(this);
  }
}
