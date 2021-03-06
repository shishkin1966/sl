import 'package:flutter/material.dart';
import 'package:psb/app/ApplicationData.dart';
import 'package:psb/app/screen/drawer/ExtDrawerPresenter.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ActionMessage.dart';
import 'package:psb/sl/message/ResponseListener.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/sl/specialist/router/Router.dart';
import 'package:psb/ui/WidgetState.dart';

class HomeScreenPresenter<HomeScreenState extends WidgetState> extends AbsPresenter<HomeScreenState>
    implements ResponseListener {
  static const String NAME = "HomeScreenPresenenter";
  static const String CreateAccount = "CreateAccount";
  static const String SortByDefault = "SortByDefault";
  static const String SortByName = "SortByName";
  static const String SortByCurrency = "SortByCurrency";
  static const String SelectAll = "SelectAll";
  static const String SelectBy = "SelectBy";

  HomeScreenPresenter(HomeScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    BuildContext context = getWidget().getScaffoldState().context;
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Router.ShowAccountsScreen:
          SLUtil.routerSpecialist.showScreen(context, Router.ShowAccountsScreen);
          return;

        case Router.ShowSettingsScreen:
          SLUtil.routerSpecialist.showScreen(context, Router.ShowSettingsScreen);
          return;

        case Router.ShowRatesScreen:
          SLUtil.routerSpecialist.showScreen(context, Router.ShowRatesScreen);
          return;

        case Router.ShowAddressScreen:
          SLUtil.routerSpecialist.showScreen(context, Router.ShowAddressScreen);
          return;

        case Router.ShowContactsScreen:
          SLUtil.routerSpecialist.showScreen(context, Router.ShowContactsScreen);
          return;

        case CreateAccount:
          _createAccount();
          return;

        case SortByDefault:
        case SortByName:
        case SortByCurrency:
          _sortBy(actionName);
          return;

        case SelectAll:
          _selectAll();
          return;

        case Actions.Refresh:
          getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
          // Получим операции
          SLUtil.repositorySpecialist.getOperations(NAME);
          return;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case SelectBy:
          _selectBy(action.getData());
          return;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    /*
    QueryBuilder qb = new SqliteQueryBuilder()
        .from(Ticker.Table)
        .select(Ticker.Columns.name)
        .whereAnd(Criteria.contains(Ticker.Columns.name, "a"))
        .orderByAscending(Ticker.Columns.name);
    String sql = qb.build();
    List parameters = qb.buildParameters();
    */

    /*
    SLUtil.getNotificationSpecialist().showGroupMessage("PSB");
    SLUtil.getNotificationSpecialist().showMessage("", "Start 1");
    SLUtil.getNotificationSpecialist().showMessage("", "Start 2");
    */

    /*
    EventHandler handler = new EventHandler<String>();
    var subscription = handler.onEvent.listen((onData) => print('$onData'));
    handler.emit("1");
    handler.emit("2");
    subscription.cancel();

    Delegate delegate = new Delegate();
    delegate.addHandler((onData) {
      if (onData.runtimeType == String) {
        print('String:$onData');
      } else if (onData.runtimeType == int) {
        print('int:$onData');
      } else {
        print("Other type:$onData");
      }
    });
    delegate.dispatch("3");
    delegate.dispatch(4);
    delegate.dispatch(5.03);
    */

    /*
    SLUtil.getFingerprintSpecialist().hasBiometrics().then((hasBiometrics) {
      if (hasBiometrics) {
        SLUtil.getFingerprintSpecialist().authenticateWithBiometrics("Отпечаток пальца").then((result) {
          if (result.hasError()) {
            Flushbar flushbar = SLUtil.getUISpecialist().getErrorFlushbar(result.getErrorText());
            flushbar.show(getWidget().context);
          } else {
            _getdata();
          }
        });
      } else {
        _getdata();
      }
    });
    */

    _getdata();
  }

  void _getdata() {
    getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
    // Получим счета
    SLUtil.repositorySpecialist.getAccounts(NAME);
    // Получим операции
    SLUtil.repositorySpecialist.getOperations(NAME);
  }

  @override
  void response(Result result) {
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetAccounts:
          ApplicationData.instance.accounts = result.getData();
          SLUtil.addMessage(new ActionMessage.action(ExtDrawerPresenter.NAME, new ApplicationAction(Actions.Refresh)));
          break;

        case Repository.GetOperations:
          getWidget().addActions([
            new ApplicationAction(Actions.HideHorizontalProgress),
            new DataAction(Repository.GetOperations).setData(result.getData())
          ]);
          break;
      }
    } else {
      getWidget().addAction(new ApplicationAction(Actions.HideHorizontalProgress));
      SLUtil.uiSpecialist.showErrorToast(result.getErrorText());
    }
  }

  void _createAccount() {}

  void _sortBy(String action) {}

  void _selectAll() {}

  void _selectBy(String currency) {}
}
