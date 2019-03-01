import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psb/app/repository/Repository.dart';
import 'package:psb/app/router/Router.dart';
import 'package:psb/app/screen/drawer/ExtDrawerPresenter.dart';
import 'package:psb/app/screen/drawer/ExtDrawerWidget.dart';
import 'package:psb/app/screen/home/HomeScreenData.dart';
import 'package:psb/app/screen/home/HomeScreenPresenter.dart';
import 'package:psb/app/screen/home/HomeScreenWidget.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/message/ActionMessage.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/state/States.dart';
import 'package:psb/ui/Application.dart';
import 'package:psb/ui/WidgetState.dart';

class HomeScreenState extends WidgetState<HomeScreenWidget> {
  HomeScreenData _data = new HomeScreenData();
  int _exitCount = 0;

  HomeScreenState() : super();

  @override
  void onAction(final Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.ShowHorizontalProgress:
          _data.progress = true;
          break;

        case Actions.HideHorizontalProgress:
          _data.progress = false;
          break;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Repository.GetOperations:
          _data.operations = action.getData();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        if (SLUtil.getPresenterUnion().hasSubscriber(ExtDrawerPresenter.NAME)) {
          ExtDrawerPresenter presenter = SLUtil.getPresenterUnion().getPresenter(ExtDrawerPresenter.NAME);
          if (presenter.getState() == States.StateReady) {
            Navigator.pop(widgetContext);
            return false;
          }
        }
        _exitCount++;
        if (_exitCount == 1) {
          String actionName = SLUtil.getString(context, 'exit');
          String text = SLUtil.getString(context, 'press_twice');
          if (snackbar != null) {
            Scaffold.of(widgetContext).removeCurrentSnackBar();
            snackbar = null;
          }
          snackbar = SLUtil.getUISpecialist().getSnackBarWithAction(
              text, new Duration(seconds: 4), actionName, new ApplicationAction(Actions.ExitApplication));
          Scaffold.of(widgetContext).showSnackBar(snackbar);
          Future.delayed(const Duration(seconds: 4), () {
            _exitCount = 0;
            setConnectivityState();
          });
        } else {
          SLUtil.addMessage(new ActionMessage.action(Application.NAME, new ApplicationAction(Actions.ExitApplication)));
        }
        return false;
      },
      child: new Scaffold(
        backgroundColor: Color(0x00000000),
        drawer: new ExtDrawerWidget(),
        body: new Builder(builder: (BuildContext context) {
          widgetContext = context;
          return SafeArea(top: true, child: _getWidget());
        }),
      ),
    );
  }

  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new HomeScreenPresenter(this);
  }

  Widget _getWidget() {
    return new LayoutBuilder(builder: (context, constraints) {
      return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new Stack(
          fit: StackFit.expand,
          children: [
            new Container(
              color: Color(0xffEEF5FF),
            ),
            _showOperations(context, constraints),
            _showMenuButton(context, constraints),
            _showHorizontalProgress(context, constraints),
          ],
        ),
      );
    });
  }

  Future<Null> _onRefresh() async {
    getPresenter().addAction(new ApplicationAction(Actions.Refresh));
    return null;
  }

  Widget _showOperations(BuildContext context, BoxConstraints constraints) {
    if (_data.operations.isNotEmpty) {
      return new ListView.builder(
          itemCount: _data.operations.length,
          itemBuilder: (context, position) {
            return new Material(
              color: Color(0xffffffff),
              child: InkWell(
                onTap: () {
                  SLUtil.getUISpecialist().showToast("OnTapOperation:" + _data.operations[position].name);
                  Router.showOperationScreen(context, _data.operations[position]);
                },
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      height: 4,
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                          child: new Icon(Icons.message),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: new Text(
                                      DateFormat("dd.MM.yyyy").format(_data.operations[position].when),
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.fromLTRB(8, 0, 12, 0),
                                    child: new Text(
                                      _data.operations[position].amount.toString(),
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              new Text(
                                DateFormat("HH:mm").format(_data.operations[position].when),
                                style: TextStyle(color: Color(0xff808080), fontSize: 16),
                              ),
                              new Text(
                                _data.operations[position].status,
                                style: TextStyle(color: Color(0xff2E9E5F), fontSize: 14),
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                child: new Text(
                                  _data.operations[position].name,
                                  style: TextStyle(color: Color(0xff427CB9), fontSize: 20),
                                ),
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
    } else {
      return new Positioned(
        top: 0,
        left: 0,
        height: 0,
        width: constraints.maxWidth,
        child: new Container(),
      );
    }
  }

  Widget _showHorizontalProgress(BuildContext context, BoxConstraints constraints) {
    if (_data.progress) {
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
    } else {
      return new Positioned(
        top: 0,
        left: 0,
        height: 0,
        width: constraints.maxWidth,
        child: new Container(),
      );
    }
  }

  Widget _showMenuButton(BuildContext context, BoxConstraints constraints) {
    if (_data.menuButton) {
      return new Positioned(
        left: constraints.maxWidth - 44,
        top: constraints.maxHeight - 44,
        child: new Material(
          child: InkWell(
            onTap: () {
              _showModalBottomSheet(context);
            },
            child: new Container(
              width: 44,
              height: 44,
              child: Image.asset("assets/images/ic_menu_button.png"),
            ),
          ),
        ),
      );
    } else {
      return new Positioned(
        top: 0,
        left: 0,
        height: 0,
        width: constraints.maxWidth,
        child: new Container(),
      );
    }
  }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: new Text(SLUtil.getString(context, 'templates')),
                  onTap: () {
                    Navigator.pop(context);
                    getPresenter().addAction(new ApplicationAction(HomeScreenPresenter.CreateAccount));
                  },
                ),
                new Container(
                  height: 1,
                  color: Color(0xffd9d9d9),
                ),
                new ListTile(
                  title: new Text(SLUtil.getString(context, 'sort_by')),
                  onTap: () {
                    Navigator.pop(context);
                    getPresenter().addAction(new ApplicationAction(HomeScreenPresenter.SortBy));
                  },
                ),
                new Container(
                  height: 1,
                  color: Color(0xffd9d9d9),
                ),
                new ListTile(
                  title: new Text(SLUtil.getString(context, 'select_by')),
                  onTap: () {
                    Navigator.pop(context);
                    getPresenter().addAction(new ApplicationAction(HomeScreenPresenter.SelectBy));
                  },
                ),
              ],
            ),
          );
        });
  }
}
