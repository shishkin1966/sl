import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/screen/Rates/RatesScreenPresenter.dart';
import 'package:psb/app/screen/Rates/RatesScreenWidget.dart';
import 'package:psb/app/screen/rates/RatesScreenData.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/ui/WidgetState.dart';

class RatesScreenState extends WidgetState<RatesScreenWidget> {
  static const String WidgetHorizontalProgress = 'HorizontalProgress';
  static const String WidgetRates = 'WidgetRates';

  RatesScreenData _data = new RatesScreenData();

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
    if (getVisible(WidgetHorizontalProgress)) {
      list.add(_showHorizontalProgress(context, constraints));
    }
    if (getVisible(WidgetRates)) {
      list.add(_showRates(context, constraints));
    }
    return list;
  }

  Widget _showRates(BuildContext context, BoxConstraints constraints) {
    return new ListView.builder(
        itemCount: _data.tickers.length,
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
                                      _data.tickers[position].name,
                                      style: TextStyle(color: Colors.black, fontSize: 20),
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

  Future<Null> _onRefresh() async {
    getPresenter().addAction(new ApplicationAction(Actions.Refresh));
    return null;
  }

  Widget _showHorizontalProgress(BuildContext context, BoxConstraints constraints) {
    return new Positioned(
      top: 0,
      left: 0,
      width: constraints.maxWidth,
      child: new LinearProgressIndicator(
        backgroundColor: Color(0xffffffff),
        valueColor: new AlwaysStoppedAnimation<Color>(
          Color(0xff00ff00),
        ),
      ),
    );
  }

  @override
  void onAction(final Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.ShowHorizontalProgress:
          setVisible(WidgetHorizontalProgress);
          break;

        case Actions.HideHorizontalProgress:
          setUnvisible(WidgetHorizontalProgress);
          break;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Repository.GetRates:
          _data.tickers = action.getData();
          if (_data.tickers.isNotEmpty) {
            setVisible(WidgetRates);
          } else {
            setUnvisible(WidgetRates);
          }
          break;
      }
    }
  }
}
