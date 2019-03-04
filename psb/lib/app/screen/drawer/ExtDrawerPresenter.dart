import 'package:flutter/material.dart';
import 'package:psb/app/router/Router.dart';
import 'package:psb/app/screen/home/HomeScreenPresenter.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class ExtDrawerPresenter<ExtDrawerState extends WidgetState> extends AbsPresenter<ExtDrawerState> {
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

        case Router.ShowAccountsScreen:
          Navigator.pop(getWidget().context);
          HomeScreenPresenter presenter = SLUtil.getPresenterUnion().getPresenter(HomeScreenPresenter.NAME);
          presenter.addAction(action);
          break;

        case Router.ShowSettingsScreen:
          Navigator.pop(getWidget().context);
          HomeScreenPresenter presenter = SLUtil.getPresenterUnion().getPresenter(HomeScreenPresenter.NAME);
          presenter.addAction(action);
          break;

        case Router.ShowRatesScreen:
          Navigator.pop(getWidget().context);
          HomeScreenPresenter presenter = SLUtil.getPresenterUnion().getPresenter(HomeScreenPresenter.NAME);
          presenter.addAction(action);
          break;

        case Router.ShowAddressScreen:
          Navigator.pop(getWidget().context);
          HomeScreenPresenter presenter = SLUtil.getPresenterUnion().getPresenter(HomeScreenPresenter.NAME);
          presenter.addAction(action);
          break;

        case Router.ShowContactsScreen:
          Navigator.pop(getWidget().context);
          HomeScreenPresenter presenter = SLUtil.getPresenterUnion().getPresenter(HomeScreenPresenter.NAME);
          presenter.addAction(action);
          break;
      }
    }
  }
}
