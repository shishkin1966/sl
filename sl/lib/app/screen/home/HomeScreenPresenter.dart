import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sl/app/screen/home/HomeChangeState.dart';
import 'package:sl/app/screen/second/SecondScreen.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/AbsPresenter.dart';
import 'package:sl/sl/request/ResponseListener.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

class HomeScreenPresenter<HomeScreenState extends LifecycleWidgetState> extends AbsPresenter<HomeScreenState>
    implements ResponseListener {
  static const String NAME = "HomeScreenPresenenter";
  static const String Increment = "Increment";
  static const String Response = "Response";

  HomeScreenPresenter(LifecycleWidgetState<StatefulWidget> lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onOrder(Order order) {
    switch (order.getName()) {
      case Increment:
        addAction(Increment, order.getValue());
        break;

      case Actions.OnPressed:
        Navigator.push(
          getLifecycleState().context,
          MaterialPageRoute(builder: (context) => SecondScreen()),
        );
        break;
    }
  }

  @override
  void response(Result result) {
    final HomeChangeState stateChange = new HomeChangeState();
    stateChange.title = result.getData() as String;
    addAction(Response, stateChange);
  }
}
