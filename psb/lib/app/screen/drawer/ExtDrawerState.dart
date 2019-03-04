import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:psb/app/data/Account.dart';
import 'package:psb/app/repository/ApplicationData.dart';
import 'package:psb/app/router/Router.dart';
import 'package:psb/app/screen/drawer/ExtDrawerPresenter.dart';
import 'package:psb/app/screen/drawer/ExtDrawerWidget.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';

class ExtDrawerState extends WidgetState<ExtDrawerWidget> {
  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new ExtDrawerPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: SafeArea(
        top: true,
        child: new Container(
          color: Color(0xff074a80),
          child: new Stack(
            children: _getWidget(),
          ),
        ),
      ),
    );
  }

  List<Widget> _getWidget() {
    double widthWidget = MediaQuery.of(context).size.width;
    List<Widget> list = new List();
    list.add(new Align(
      alignment: Alignment.topCenter,
      widthFactor: 1,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Material(
            color: Color(0xff377ad0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                SLUtil.getUISpecialist().showToast('OnTapUser');
              },
              child: new Container(
                height: 72,
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill, image: AssetImage("assets/images/shishkin.png")))),
                    new Container(
                      width: widthWidget * 0.6,
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: new Text(
                        SLUtil.getString(context, 'user'),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Container(
            height: 1,
            color: Color(0xffd9d9d9),
          ),
          // Курсы валют
          new Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            height: 56,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        '\$',
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              'Покупка 65.38',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            new Text(
                              'Продажа 65.75',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: 1,
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  color: Color(0xffd9d9d9),
                ),
                new Expanded(
                  flex: 1,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        '€',
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              'Покупка 74.15',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            new Text(
                              'Продажа 74.49',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Container(
            height: 1,
            color: Color(0xffd9d9d9),
          ),
          // Счета
          ApplicationData.instance.accounts.isEmpty
              ? new Container()
              : new Material(
                  color: Color(0xff377ad0),
                  child: InkWell(
                    onTap: () {
                      getPresenter().addAction(new ApplicationAction(Router.ShowAccountsScreen));
                    },
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              SLUtil.getString(context, 'accounts'),
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          new Container(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: _getAccounts(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ApplicationData.instance.accounts.isEmpty
              ? new Container()
              : new Container(
                  height: 1,
                  color: Color(0xffd9d9d9),
                ),
        ],
      ),
    ));
    list.add(
      new Align(
        alignment: Alignment.bottomCenter,
        widthFactor: 1,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 1,
              color: Color(0xffd9d9d9),
            ),
            // Настройки
            new Material(
              color: Color(0xff377ad0),
              child: InkWell(
                onTap: () {
                  getPresenter().addAction(new ApplicationAction(Router.ShowSettingsScreen));
                },
                child: new Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  height: 40,
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      SLUtil.getString(context, 'settings'),
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
            new Container(
              height: 80,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: new Material(
                      color: Color(0xff377ad0),
                      child: InkWell(
                        onTap: () {
                          getPresenter().addAction(new ApplicationAction(Router.ShowRatesScreen));
                        },
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              height: 48,
                              width: 48,
                              child: new Image(
                                image: new AssetImage("assets/images/ic_rates_white.png"),
                              ),
                            ),
                            new Text(
                              SLUtil.getString(context, 'currency_rates'),
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    width: 1,
                    color: Color(0xffd9d9d9),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Material(
                      color: Color(0xff377ad0),
                      child: InkWell(
                        onTap: () {
                          getPresenter().addAction(new ApplicationAction(Router.ShowAddressScreen));
                        },
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              height: 48,
                              width: 48,
                              child: new Image(
                                image: new AssetImage("assets/images/ic_office_white.png"),
                              ),
                            ),
                            new Text(
                              SLUtil.getString(context, 'address'),
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    width: 1,
                    color: Color(0xffd9d9d9),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Material(
                      color: Color(0xff377ad0),
                      child: InkWell(
                        onTap: () {
                          getPresenter().addAction(new ApplicationAction(Router.ShowContactsScreen));
                        },
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              height: 48,
                              width: 48,
                              child: new Image(
                                image: new AssetImage("assets/images/ic_contact_white.png"),
                              ),
                            ),
                            new Text(
                              SLUtil.getString(context, 'communication'),
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return list;
  }

  List<Widget> _getAccounts() {
    List<Widget> list = new List();
    int length = ApplicationData.instance.accounts.length;
    for (Account account in ApplicationData.instance.accounts) {
      list.add(
        new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Text(
              account.amount.toString() + ' ' + account.currency.iso,
              style: TextStyle(color: Colors.white, fontSize: length == 1 ? 16 : 14),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      );
    }
    return list;
  }

  @override
  void onAction(final Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.Refresh:
          break;
      }
    }
  }
}
