import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/repository/Repository.dart';
import 'package:psb/app/screen/contacts/ContactsScreenData.dart';
import 'package:psb/app/screen/contacts/ContactsScreenPresenter.dart';
import 'package:psb/app/screen/contacts/ContactsScreenWidget.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';

class ContactsScreenState extends WidgetState<ContactsScreenWidget> {
  ContactsScreenData _data = new ContactsScreenData();

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
        backgroundColor: Color(0x00000000),
        body: new Builder(builder: (BuildContext context) {
          widgetContext = context;
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
          children: [
            new Container(
              color: Color(0xffEEF5FF),
            ),
            _showHorizontalProgress(context, constraints),
            new Column(
              children: <Widget>[
                _showFilter(context, constraints),
                new Expanded(
                  child: _showContacts(context, constraints),
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _showFilter(BuildContext context, BoxConstraints constraints) {
    return new Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      height: 40,
      child: new TextField(
        decoration: InputDecoration(
          hintText: SLUtil.getString(context, "search"),
          icon: Icon(Icons.search),
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) {
          getPresenter().addAction(new DataAction(ContactsScreenPresenter.ChangeFilter).setData(text));
        },
        maxLines: 1,
      ),
    );
  }

  Widget _showContacts(BuildContext context, BoxConstraints constraints) {
    if (_data.contacts.isNotEmpty) {
      return new ListView.builder(
          shrinkWrap: true,
          itemCount: _data.contacts.length,
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
                                        _data.contacts[position].displayName,
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
    } else {
      return new Container();
    }
  }

  Future<Null> _onRefresh() async {
    getPresenter().addAction(new ApplicationAction(Actions.Refresh));
    return null;
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
        case Repository.GetContacts:
          _data.contacts = action.getData();
          break;
      }
    }
  }
}
