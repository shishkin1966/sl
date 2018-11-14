import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sl/app/screen/home/HomeScreenPresenter.dart';
import 'package:sl/sl/SL.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/AbsPresenter.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnion.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:sl/ui/LifecycleState.dart';

class SecondScreenPresenenter<HomeScreenState extends LifecycleState> extends AbsPresenter<HomeScreenState> {
  static const String NAME = "SecondScreenPresenenter";

  SecondScreenPresenenter(LifecycleState<StatefulWidget> lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onOrder(Order order) {
    switch (order.getName()) {
      case HomeScreenPresenenter.Increment:
        final Presenter presenter =
            (SL.instance.get(PresenterUnionImpl.NAME) as PresenterUnion).getSubscriber(HomeScreenPresenenter.NAME);
        presenter.doOrder(HomeScreenPresenenter.Increment, ["4"]);
        break;

      case Actions.OnPressed:
        Navigator.pop(getLifecycleState().context);
        break;
    }
  }
}
