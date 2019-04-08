import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:psb/app/common/DataWidget.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/app/screen/drawer/ExtDrawerPresenter.dart';
import 'package:psb/app/screen/drawer/ExtDrawerWidget.dart';
import 'package:psb/app/screen/home/HomeScreenPresenter.dart';
import 'package:psb/app/screen/home/HomeScreenWidget.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/common/WithoutGlowBehavior.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/message/ActionMessage.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/sl/state/States.dart';
import 'package:psb/ui/AppColor.dart';
import 'package:psb/ui/Application.dart';
import 'package:psb/ui/Dimen.dart';
import 'package:psb/ui/WidgetState.dart';

class HomeScreenState extends WidgetState<HomeScreenWidget> {
  static const double ExpandedBottomMenuHeight = 122.0 + Dimen.ShadowHeight;
  static const double RolledBottomMenuHeight = 41.0 + Dimen.ShadowHeight;

  int _exitCount = 0;
  double _bottomPosition = RolledBottomMenuHeight;
  GlobalKey _progressKey = new GlobalKey();
  GlobalKey _operationsKey = new GlobalKey();

  HomeScreenState() : super();

  @override
  void onAction(Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.ShowHorizontalProgress:
          action.setStateNonChanged();
          (_progressKey.currentState as HorizontalProgressWidgetState)
              ?.onChange(true);
          return;

        case Actions.HideHorizontalProgress:
          action.setStateNonChanged();
          (_progressKey.currentState as HorizontalProgressWidgetState)
              ?.onChange(false);
          return;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Repository.GetOperations:
          action.setStateNonChanged();
          (_operationsKey.currentState as OperationsWidgetState)
              ?.onChange(action.getData());
          return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        if (SLUtil.getPresenterUnion().hasSubscriber(ExtDrawerPresenter.NAME)) {
          ExtDrawerPresenter presenter =
              SLUtil.getPresenterUnion().getPresenter(ExtDrawerPresenter.NAME);
          if (presenter.getState() == States.StateReady) {
            Navigator.pop(getScaffoldState().context);
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
          snackbar = SLUtil.getUISpecialist().getSnackBar(text,
              actionText: actionName,
              action: new ApplicationAction(Actions.ExitApplication));
          state.showSnackBar(snackbar);
          Future.delayed(const Duration(seconds: 4), () {
            _exitCount = 0;
            setConnectivityState();
          });
        } else {
          SLUtil.addMessage(new ActionMessage.action(Application.NAME,
              new ApplicationAction(Actions.ExitApplication)));
        }
        return false;
      },
      child: new Scaffold(
        key: getScaffoldKey(),
        backgroundColor: Colors.transparent,
        drawer: new ExtDrawerWidget(),
        body: new Builder(builder: (BuildContext context) {
          return SafeArea(
            top: true,
            child: _getWidget(),
          );
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
            children: _getChildren(context, constraints),
          ),
        );
      },
    );
  }

  List<Widget> _getChildren(BuildContext context, BoxConstraints constraints) {
    List<Widget> list = new List();
    list.add(new Container(
      color: Color(AppColor.Background),
    ));
    list.add(_showRefreshOperations(context, constraints));
    list.add(_showHorizontalProgress(context, constraints));
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
      child: new Column(
        children: <Widget>[
          new Container(
            height: Dimen.ShadowHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, Color(AppColor.Shadow)],
              ),
            ),
          ),
          new Container(
            color: Color(AppColor.Blue),
            height: _bottomPosition - Dimen.ShadowHeight,
            child: new Container(
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
                        _bottomPosition -=
                            notification.dragDetails.delta.dy * 4;
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
                  child: new ScrollConfiguration(
                    behavior: new WithoutGlowBehavior(),
                    child: new ListView(
                      children: <Widget>[
                        new Material(
                          color: Color(AppColor.BlueMenu),
                          child: InkWell(
                            onTap: () {
                              SLUtil.getUISpecialist()
                                  .showToast('OnTapPayments');
                              _bottomPosition = RolledBottomMenuHeight;
                              setState(() {});
                            },
                            child: new Container(
                              padding: EdgeInsets.fromLTRB(
                                  Dimen.Dimen_12, 0, Dimen.Dimen_12, 0),
                              height: Dimen.Dimen_40,
                              child: new Align(
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  SLUtil.getString(context, 'payments'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          height: 1,
                          color: Color(AppColor.DividerMenu),
                        ),
                        new Material(
                          color: Color(AppColor.BlueMenu),
                          child: InkWell(
                            onTap: () {
                              _showSortMenu(context);
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          height: 1,
                          color: Color(AppColor.DividerMenu),
                        ),
                        new Material(
                          color: Color(AppColor.BlueMenu),
                          child: InkWell(
                            onTap: () {
                              _showSelectMenu(context);
                              _bottomPosition = RolledBottomMenuHeight;
                              setState(() {});
                            },
                            child: new Container(
                              padding: EdgeInsets.fromLTRB(
                                  Dimen.Dimen_12, 0, Dimen.Dimen_12, 0),
                              height: Dimen.Dimen_40,
                              child: new Align(
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  SLUtil.getString(context, 'select_by'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                title: new Text(SLUtil.getString(bc, "default")),
                onTap: () {
                  Navigator.pop(bc);
                  getPresenter()?.addAction(
                      new ApplicationAction(HomeScreenPresenter.SortByDefault));
                },
              ),
              new Container(
                height: 1,
                color: Color(AppColor.DividerMenu),
              ),
              new ListTile(
                title: new Text(SLUtil.getString(bc, "sort_name")),
                onTap: () {
                  Navigator.pop(bc);
                  getPresenter()?.addAction(
                      new ApplicationAction(HomeScreenPresenter.SortByName));
                },
              ),
              new Container(
                height: 1,
                color: Color(AppColor.DividerMenu),
              ),
              new ListTile(
                title: new Text(SLUtil.getString(bc, "sort_currency")),
                onTap: () {
                  Navigator.pop(bc);
                  getPresenter()?.addAction(new ApplicationAction(
                      HomeScreenPresenter.SortByCurrency));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSelectMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                title: new Text(SLUtil.getString(bc, "all")),
                onTap: () {
                  Navigator.pop(bc);
                  getPresenter()?.addAction(
                      new ApplicationAction(HomeScreenPresenter.SortByDefault));
                },
              ),
              new Container(
                height: 1,
                color: Color(AppColor.DividerMenu),
              ),
              new ListTile(
                title: new Text("\$"),
                onTap: () {
                  Navigator.pop(bc);
                  getPresenter()?.addAction(
                      new DataAction(HomeScreenPresenter.SelectBy)
                          .setData("\$"));
                },
              ),
              new Container(
                height: 1,
                color: Color(AppColor.DividerMenu),
              ),
              new ListTile(
                title: new Text("₽"),
                onTap: () {
                  Navigator.pop(bc);
                  getPresenter()?.addAction(
                      new DataAction(HomeScreenPresenter.SelectBy)
                          .setData("₽"));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showRefreshOperations(
      BuildContext context, BoxConstraints constraints) {
    return new LayoutBuilder(builder: (context, constraints) {
      return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new Container(
          height: constraints.maxHeight - _bottomPosition + Dimen.ShadowHeight,
          width: constraints.maxWidth,
          child: new OperationsWidget(key: _operationsKey),
        ),
      );
    });
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
}

class OperationsWidget extends DataWidget {
  OperationsWidget({Key key}) : super(key: key);

  @override
  OperationsWidgetState createState() =>
      new OperationsWidgetState(new List<Operation>());
}

class OperationsWidgetState extends DataWidgetState<List<Operation>> {
  OperationsWidgetState(List<Operation> data) : super(data);

  @override
  Widget getWidget() {
    return new ListView.builder(
        itemCount: getData().length,
        itemBuilder: (context, position) {
          return new Material(
            color: Color(0xffffffff),
            child: InkWell(
              onTap: () {
                _showEditOperationName(context, getData()[position])
                    .then((onValue) {
                  if (!StringUtils.isNullOrEmpty(onValue)) {
                    getData()[position].name = onValue;
                    setState(() {});
                  }
                });
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
                        padding: EdgeInsets.fromLTRB(
                            Dimen.Dimen_12, 0, Dimen.Dimen_8, 0),
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
                                    DateFormat("dd.MM.yyyy")
                                        .format(getData()[position].when),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.fromLTRB(
                                      Dimen.Dimen_8, 0, Dimen.Dimen_12, 0),
                                  child: new Text(
                                    getData()[position].amount.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            new Text(
                              DateFormat("HH:mm")
                                  .format(getData()[position].when),
                              style: TextStyle(
                                  color: Color(0xff808080), fontSize: 16),
                            ),
                            new Text(
                              getData()[position].status,
                              style: TextStyle(
                                  color: Color(0xff2E9E5F), fontSize: 14),
                            ),
                            new Container(
                              padding:
                                  EdgeInsets.fromLTRB(0, 0, Dimen.Dimen_12, 0),
                              child: new Text(
                                getData()[position].name,
                                style: TextStyle(
                                    color: Color(0xff427CB9), fontSize: 20),
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
  }

  Future _showEditOperationName(
      BuildContext context, Operation operation) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            new TextEditingController(text: operation.name);
        controller.selection = new TextSelection(
            baseOffset: operation.name.length,
            extentOffset: operation.name.length);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimen.Dimen_12))),
          contentPadding:
              EdgeInsets.fromLTRB(Dimen.Dimen_12, 0, Dimen.Dimen_12, 0),
          title: new Text(SLUtil.getString(context, "operation")),
          content: new TextFormField(
            controller: controller,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(SLUtil.getString(context, "ok")),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
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
