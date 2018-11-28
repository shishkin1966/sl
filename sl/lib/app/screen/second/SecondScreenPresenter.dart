import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sl/app/screen/home/HomeScreenData.dart';
import 'package:sl/app/screen/home/HomeScreenPresenter.dart';
import 'package:sl/sl/SL.dart';
import 'package:sl/sl/SLUtil.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/action/ApplicationAction.dart';
import 'package:sl/sl/action/DataAction.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/message/ResultMessage.dart';
import 'package:sl/sl/observe/ObjectObservable.dart';
import 'package:sl/sl/observe/ObjectObservableSubscriber.dart';
import 'package:sl/sl/presenter/AbsPresenter.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnion.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

class SecondScreenPresenter<HomeScreenState extends LifecycleWidgetState> extends AbsPresenter<HomeScreenState>
    implements ObjectObservableSubscriber {
  static const String NAME = "SecondScreenPresenenter";
  static const String OnChangeObject = "OnChangeObject";

  SecondScreenPresenter(LifecycleWidgetState<StatefulWidget> lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case HomeScreenPresenter.Increment:
          final Presenter presenter =
              (SL.instance.get(PresenterUnionImpl.NAME) as PresenterUnion).getSubscriber(HomeScreenPresenter.NAME);
          HomeScreenData data = new HomeScreenData();
          data.counter = 4;
          presenter.addAction(new DataAction(HomeScreenPresenter.Increment).setData(data));
          break;

        case Actions.OnPressed:
          Navigator.pop(getLifecycleState().context);
          break;
      }
      return;
    }
  }

  @override
  void onReady() {
    super.onReady();

    test();
  }

  void test() async {
    final Result result = new Result<String>("Это пришло письмо");
    SLUtil.getMessengerUnion().addMessage(new ResultMessage.result(HomeScreenPresenter.NAME, result));

    for (int i = 0; i < 3; i++) {
      new Timer(const Duration(seconds: 1), () => SLUtil.onChange("Test 0"));
    }
  }

  @override
  List<String> getSpecialistSubscription() {
    final List<String> list = super.getSpecialistSubscription();
    list.add(ObservableUnionImpl.NAME);
    return list;
  }

  @override
  List<String> getListenObjects() {
    return ["Test 0", "Test 1"];
  }

  @override
  List<String> getObservable() {
    return [ObjectObservable.NAME];
  }

  @override
  void onChange<String>(String object) {
    final HomeScreenData data = new HomeScreenData();
    data.title = ("Изменился объект:$object");
    getLifecycleState().addAction(new DataAction(OnChangeObject).setData(data));
  }
}
