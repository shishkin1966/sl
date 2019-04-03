import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/common/DataWidget.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/app/screen/Rates/RatesScreenPresenter.dart';
import 'package:psb/app/screen/Rates/RatesScreenWidget.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/ui/WidgetState.dart';

class RatesScreenState extends WidgetState<RatesScreenWidget> {
  GlobalKey _ratesKey = new GlobalKey();
  GlobalKey _progressKey = new GlobalKey();

  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new RatesScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: new Scaffold(
        key: getScaffoldKey(),
        backgroundColor: Color(0x00000000),
        body: new Builder(builder: (BuildContext context) {
          return SafeArea(top: true, child: _getWidget());
        }),
      ),
    );
  }

  Widget _getWidget() {
    return new LayoutBuilder(builder: (context, constraints) {
      return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new Stack(
          fit: StackFit.expand,
          children: _getChildren(context, constraints),
        ),
      );
    });
  }

  List<Widget> _getChildren(BuildContext context, BoxConstraints constraints) {
    List<Widget> list = new List();
    list.add(new Container(
      color: Color(0xffEEF5FF),
    ));
    list.add(_showHorizontalProgress(context, constraints));
    list.add(_showRefreshRates(context, constraints));
    return list;
  }

  Widget _showRefreshRates(BuildContext context, BoxConstraints constraints) {
    return new LayoutBuilder(builder: (context, constraints) {
      return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: new RatesWidget(key: _ratesKey),
        ),
      );
    });
  }

  Future<Null> _onRefresh() async {
    (_ratesKey.currentState as RatesWidgetState)?.onChange(new List());
    getPresenter().addAction(new ApplicationAction(Actions.Refresh));
    return null;
  }

  Widget _showHorizontalProgress(
      BuildContext context, BoxConstraints constraints) {
    return new Positioned(
      top: 0,
      left: 0,
      width: constraints.maxWidth,
      child: new HorizontalProgressWidget(
        key: _progressKey,
      ),
    );
  }

  @override
  void onAction(final Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.ShowHorizontalProgress:
          action.setStateNonChanged();
          (_progressKey.currentState as HorizontalProgressWidgetState)
              ?.onChange(true);
          break;

        case Actions.HideHorizontalProgress:
          action.setStateNonChanged();
          (_progressKey.currentState as HorizontalProgressWidgetState)
              ?.onChange(false);
          break;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Repository.GetRates:
          action.setStateNonChanged();
          (_ratesKey.currentState as RatesWidgetState)
              ?.onChange(action.getData());
          break;
      }
    }
  }
}

class RatesWidget extends DataWidget {
  RatesWidget({Key key}) : super(key: key);

  @override
  RatesWidgetState createState() => new RatesWidgetState(new List<Ticker>());
}

class RatesWidgetState extends DataWidgetState<List<Ticker>> {
  RatesWidgetState(List<Ticker> data) : super(data);

  @override
  Widget getWidget() {
    return new ListView.builder(
        itemCount: getData().length,
        itemBuilder: (context, position) {
          return new Material(
            color: Color(0xffffffff),
            child: InkWell(
              onTap: () {},
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    height: 4,
                  ),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  flex: 1,
                                  child: new Container(
                                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    child: new Text(
                                      getData()[position].name,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  new Container(
                    height: 4,
                  ),
                  new Container(
                    height: 1,
                    color: Color(0xffd9d9d9),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class HorizontalProgressWidget extends DataWidget {
  HorizontalProgressWidget({Key key}) : super(key: key);

  @override
  HorizontalProgressWidgetState createState() =>
      new HorizontalProgressWidgetState(false);
}

class HorizontalProgressWidgetState extends DataWidgetState<bool> {
  HorizontalProgressWidgetState(bool data) : super(data);

  @override
  Widget getWidget() {
    if (getData()) {
      return new LinearProgressIndicator(
        backgroundColor: Color(0xffffffff),
        valueColor: new AlwaysStoppedAnimation<Color>(
          Color(0xff00ff00),
        ),
      );
    } else {
      return new Container();
    }
  }
}
