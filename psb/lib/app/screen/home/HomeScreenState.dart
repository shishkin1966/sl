import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:psb/ui/Dimen.dart';
import 'package:psb/ui/WidgetState.dart';

class HomeScreenState extends WidgetState<HomeScreenWidget> {
  static const double ExpandedBottomMenuHeight = 122;
  static const double RolledBottomMenuHeight = 42;

  HomeScreenData _data = new HomeScreenData();
  int _exitCount = 0;
  double _bottomPosition = RolledBottomMenuHeight;

  HomeScreenState() : super();

  @override
  void onAction(final Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.ShowHorizontalProgress:
          setModified(HomeScreenPresenter.WidgetHorizontalProgress);
          break;

        case Actions.HideHorizontalProgress:
          removeModified(HomeScreenPresenter.WidgetHorizontalProgress);
          break;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Repository.GetOperations:
          _data.operations = action.getData();
          if (_data.operations.isEmpty) {
            removeModified(HomeScreenPresenter.WidgetRefreshOperations);
          } else {
            setModified(HomeScreenPresenter.WidgetRefreshOperations);
          }
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
          ScaffoldState state = getScaffoldState();
          if (snackbar != null) {
            state.removeCurrentSnackBar();
            snackbar = null;
          }
          snackbar = SLUtil.getUISpecialist().getSnackBarWithAction(
              text, new Duration(seconds: 4), actionName, new ApplicationAction(Actions.ExitApplication));
          state.showSnackBar(snackbar);
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
        key: getKey(),
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
    return new LayoutBuilder(
      builder: (context, constraints) {
        return new GestureDetector(
          onTap: () {
            _bottomPosition = RolledBottomMenuHeight;
            setState(() {});
          },
          child: new Stack(
            fit: StackFit.expand,
            children: _refreshWidgets(context, constraints),
          ),
        );
      },
    );
  }

  List<Widget> _refreshWidgets(BuildContext context, BoxConstraints constraints) {
    List<Widget> list = new List();
    list.add(new Container(
      color: Color(0xffEEF5FF),
    ));
    if (getModified(HomeScreenPresenter.WidgetRefreshOperations)) {
      list.add(_showRefreshOperations(context, constraints));
    }
    if (getModified(HomeScreenPresenter.WidgetHorizontalProgress)) {
      list.add(_showHorizontalProgress(context, constraints));
    }
    list.add(_showBottomMenu(context, constraints));
    return list;
  }

  Future<Null> _onRefresh() async {
    getPresenter().addAction(new ApplicationAction(Actions.Refresh));
    return null;
  }

  Widget _showBottomMenu(BuildContext context, BoxConstraints constraints) {
    return new Positioned(
      top: constraints.maxHeight - _bottomPosition,
      height: _bottomPosition,
      left: 0,
      width: constraints.maxWidth,
      child: new Container(
          color: Color(0xff074a80),
          height: _bottomPosition,
          width: double.infinity,
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.forward) {
                  _bottomPosition = RolledBottomMenuHeight;
                  setState(() {});
                }
              } else if (notification is ScrollUpdateNotification) {
                if (notification.dragDetails != null) {
                  _bottomPosition -= notification.dragDetails.delta.dy * 4;
                  if (_bottomPosition < RolledBottomMenuHeight) {
                    _bottomPosition = RolledBottomMenuHeight;
                  }
                  if (_bottomPosition >= ExpandedBottomMenuHeight) {
                    _bottomPosition = ExpandedBottomMenuHeight;
                  }
                  setState(() {});
                }
              }
            },
            child: new ListView(
              children: <Widget>[
                new Material(
                  color: Color(0xff377ad0),
                  child: InkWell(
                    onTap: () {
                      SLUtil.getUISpecialist().showToast('OnTapPayments');
                      _bottomPosition = RolledBottomMenuHeight;
                      setState(() {});
                    },
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(Dimen.Dimen_12, 0, Dimen.Dimen_12, 0),
                      height: Dimen.Dimen_40,
                      child: new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          SLUtil.getString(context, 'payments'),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                new Container(
                  height: 1,
                  color: Color(0xffd9d9d9),
                ),
                new Material(
                  color: Color(0xff377ad0),
                  child: InkWell(
                    onTap: () {
                      SLUtil.getUISpecialist().showToast('OnTapSortBy');
                      _bottomPosition = RolledBottomMenuHeight;
                      setState(() {});
                    },
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      height: Dimen.Dimen_40,
                      child: new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          SLUtil.getString(context, 'sort_by'),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                new Container(
                  height: 1,
                  color: Color(0xffd9d9d9),
                ),
                new Material(
                  color: Color(0xff377ad0),
                  child: InkWell(
                    onTap: () {
                      SLUtil.getUISpecialist().showToast('OnTapSelectBy');
                      _bottomPosition = RolledBottomMenuHeight;
                      setState(() {});
                    },
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(Dimen.Dimen_12, 0, Dimen.Dimen_12, 0),
                      height: Dimen.Dimen_40,
                      child: new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          SLUtil.getString(context, 'select_by'),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _showRefreshOperations(BuildContext context, BoxConstraints constraints) {
    return new LayoutBuilder(builder: (context, constraints) {
      return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new Container(
          height: constraints.maxHeight - _bottomPosition,
          width: constraints.maxWidth,
          child: _showOperations(context, constraints),
        ),
      );
    });
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
                      height: Dimen.Dimen_4,
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(Dimen.Dimen_12, 0, Dimen.Dimen_8, 0),
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
                                    padding: EdgeInsets.fromLTRB(Dimen.Dimen_8, 0, Dimen.Dimen_12, 0),
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
                                padding: EdgeInsets.fromLTRB(0, 0, Dimen.Dimen_12, 0),
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
                      height: Dimen.Dimen_4,
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
      return new Container();
    }
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
}
