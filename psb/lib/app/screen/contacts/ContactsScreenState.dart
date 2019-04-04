import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/common/DataWidget.dart';
import 'package:psb/app/screen/contacts/ContactsScreenPresenter.dart';
import 'package:psb/app/screen/contacts/ContactsScreenWidget.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/ui/WidgetState.dart';

class ContactsScreenState extends WidgetState<ContactsScreenWidget> {
  GlobalKey _progressKey = new GlobalKey();
  GlobalKey _contactsKey = new GlobalKey();

  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new ContactsScreenPresenter(this);
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
          return SafeArea(
            top: true,
            child: _getWidget(),
          );
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
          children: [
            new Container(
              color: Color(0xffEEF5FF),
            ),
            new Column(
              children: <Widget>[
                _showFilter(context, constraints),
                new Container(
                  height: 1,
                  color: Color(0xffd9d9d9),
                ),
                new Expanded(
                  child: new ContactsWidget(key: _contactsKey),
                  flex: 1,
                ),
              ],
            ),
            _showHorizontalProgress(context, constraints),
          ],
        ),
      );
    });
  }

  Widget _showFilter(BuildContext context, BoxConstraints constraints) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      height: 40,
      child: new TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: SLUtil.getString(context, "search"),
          icon: Icon(Icons.search),
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) {
          getPresenter().addAction(
              new DataAction(ContactsScreenPresenter.ChangeFilter)
                  .setData(text));
        },
        maxLines: 1,
      ),
    );
  }

  Future<Null> _onRefresh() async {
    (_contactsKey.currentState as ContactsWidgetState)?.onChange(new List());
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
        case Repository.GetContacts:
          action.setStateNonChanged();
          (_contactsKey.currentState as ContactsWidgetState)
              ?.onChange(action.getData());
          return;
      }
    }
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

class ContactsWidget extends DataWidget {
  ContactsWidget({Key key}) : super(key: key);

  @override
  ContactsWidgetState createState() =>
      new ContactsWidgetState(new List<Contact>());
}

class ContactsWidgetState extends DataWidgetState<List<Contact>> {
  ContactsWidgetState(List<Contact> data) : super(data);

  @override
  Widget getWidget() {
    if (getData().isNotEmpty) {
      return new ListView.builder(
          shrinkWrap: true,
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
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: new Text(
                                        getData()[position].displayName,
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
    } else {
      return new Container();
    }
  }
}
