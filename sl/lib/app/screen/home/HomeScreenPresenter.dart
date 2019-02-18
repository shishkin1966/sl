import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sl/app/screen/home/HomeScreenData.dart';
import 'package:sl/app/screen/second/SecondScreenWidget.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/action/ApplicationAction.dart';
import 'package:sl/sl/action/DataAction.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/presenter/AbsPresenter.dart';
import 'package:sl/sl/request/ResponseListener.dart';
import 'package:sl/ui/WidgetState.dart';

class HomeScreenPresenter<HomeScreenWidgetState extends WidgetState> extends AbsPresenter<HomeScreenWidgetState>
    implements ResponseListener {
  static const String NAME = "HomeScreenPresenenter";
  static const String Increment = "Increment";
  static const String Response = "Response";

  HomeScreenPresenter(WidgetState<StatefulWidget> lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Increment:
          getWidget().addAction(action);
          break;
      }
      return;
    }

    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.OnPressed:
          Navigator.push(
            getWidget().context,
            MaterialPageRoute(builder: (context) => SecondScreenWidget()),
          );
          break;
      }
      return;
    }
  }

  @override
  void response(Result result) {
    final HomeScreenData data = new HomeScreenData();
    data.title = result.getData() as String;
    getWidget().addAction(new DataAction<HomeScreenData>(Response).setData(data));
  }
}
