import 'package:flutter/src/widgets/framework.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/AbsPresenter.dart';
import 'package:sl/ui/LifecycleState.dart';

class HomeScreenPresenenter<HomeScreenState extends LifecycleState> extends AbsPresenter<HomeScreenState> {
  static const String NAME = "HomeScreenPresenenter";
  static const String Increment = "Increment";

  int _increment = 0;

  HomeScreenPresenenter(LifecycleState<StatefulWidget> lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onOrder(Order order) {
    switch (order.getName()) {
      case Increment:
        _increment++;
        addAction(Increment, [_increment]);
        break;
    }
  }
}
