import 'package:flushbar/flushbar.dart';
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

class HomeScreenPresenter<HomeScreenState extends WidgetState>
    extends AbsPresenter<HomeScreenState> implements ResponseListener {
  static const String NAME = "HomeScreenPresenenter";
  static const String CreateAccount = "CreateAccount";
  static const String SortBy = "SortBy";
  static const String SelectBy = "SelectBy";

  HomeScreenPresenter(HomeScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      BuildContext context = getWidget().getScaffoldState().context;
      switch (actionName) {
        case Router.ShowAccountsScreen:
          SLUtil.getRouterSpecialist()
              .showScreen(context, Router.ShowAccountsScreen);
          break;

        case Router.ShowSettingsScreen:
          SLUtil.getRouterSpecialist()
              .showScreen(context, Router.ShowSettingsScreen);
          break;

        case Router.ShowRatesScreen:
          SLUtil.getRouterSpecialist()
              .showScreen(context, Router.ShowRatesScreen);
          break;

        case Router.ShowAddressScreen:
          SLUtil.getRouterSpecialist()
              .showScreen(context, Router.ShowAddressScreen);
          break;

        case Router.ShowContactsScreen:
          SLUtil.getRouterSpecialist()
              .showScreen(context, Router.ShowContactsScreen);
          break;

        case CreateAccount:
          _createAccount();
          break;

        case SortBy:
          _sortBy();
          break;

        case SelectBy:
          _selectBy();
          break;

        case Actions.Refresh:
          getWidget()
              .addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
          // Получим операции
          SLUtil.getRepositorySpecialist().getOperations(NAME);
          break;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

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

    SLUtil.getFingerprintSpecialist().hasBiometrics().then((hasBiometrics) {
      if (hasBiometrics) {
        SLUtil.getFingerprintSpecialist()
            .authenticateWithBiometrics("Отпечаток пальца")
            .then((result) {
          if (result.hasError()) {
            Flushbar flushbar = SLUtil.getUISpecialist()
                .getErrorFlushbar(result.getErrorText());
            flushbar.show(getWidget().context);
          } else {
            _getdata();
          }
        });
      } else {
        _getdata();
      }
    });
  }

  void _getdata() {
    getWidget()
        .addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
    // Получим счета
    SLUtil.getRepositorySpecialist().getAccounts(NAME);
    // Получим операции
    SLUtil.getRepositorySpecialist().getOperations(NAME);
  }

  @override
  void response(Result result) {
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetAccounts:
          ApplicationData.instance.accounts = result.getData();
          SLUtil.addMessage(new ActionMessage.action(
              ExtDrawerPresenter.NAME, new ApplicationAction(Actions.Refresh)));
          break;

        case Repository.GetOperations:
          getWidget().addActions([
            new ApplicationAction(Actions.HideHorizontalProgress),
            new DataAction(Repository.GetOperations).setData(result.getData())
          ]);
          break;
      }
    } else {
      getWidget()
          .addAction(new ApplicationAction(Actions.HideHorizontalProgress));
      SLUtil.getUISpecialist().showErrorToast(result.getErrorText());
    }
  }

  void _createAccount() {}

  void _sortBy() {}

  void _selectBy() {}
}
