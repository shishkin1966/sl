import 'package:flutter/material.dart';
import 'package:psb/app/screen/home/HomeScreenPresenter.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/ActionSubscriber.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/sl/specialist/router/Router.dart';
import 'package:psb/ui/WidgetState.dart';

class ExtDrawerPresenter<ExtDrawerState extends WidgetState> extends AbsPresenter<ExtDrawerState>
    implements ActionSubscriber {
  static const String NAME = "ExtDrawerPresenter";

  ExtDrawerPresenter(ExtDrawerState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.Refresh:
          getWidget().addAction(action);
          break;

        case Router.ShowSettingsScreen:
        case Router.ShowAccountsScreen:
        case Router.ShowRatesScreen:
        case Router.ShowAddressScreen:
        case Router.ShowContactsScreen:
          Navigator.pop(getWidget().context);
          SLUtil.getPresenterUnion().getPresenter(HomeScreenPresenter.NAME)?.addAction(action);
          break;
      }
    }
  }
}
