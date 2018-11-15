import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sl/app/screen/home/HomeViewData.dart';
import 'package:sl/app/screen/second/SecondScreen.dart';
import 'package:sl/sl/SLUtil.dart';
import 'package:sl/sl/action/Actions.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/observe/ObjectObservable.dart';
import 'package:sl/sl/observe/ObjectObservableSubscriber.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/AbsPresenter.dart';
import 'package:sl/sl/request/ResponseListener.dart';
import 'package:sl/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:sl/ui/LifecycleState.dart';

class HomeScreenPresenter<HomeScreenState extends LifecycleState> extends AbsPresenter<HomeScreenState>
    implements ResponseListener, ObjectObservableSubscriber {
  static const String NAME = "HomeScreenPresenenter";
  static const String Increment = "Increment";
  static const String Response = "Response";
  static const String OnChangeObject = "OnChangeObject";

  HomeScreenPresenter(LifecycleState<StatefulWidget> lifecycleState) : super(lifecycleState);

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
    final HomeViewData viewData = new HomeViewData();
    viewData.title = result.getData() as String;
    addAction(Response, viewData);
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
    final HomeViewData viewData = new HomeViewData();
    viewData.title = ("Изменился объект:$object");
    addAction(OnChangeObject, viewData);
  }

  @override
  void onReady() {
    super.onReady();

    for (int i = 0; i < 3; i++) {
      sleep(Duration(milliseconds: 500));
      SLUtil.onChange("Test 0");
    }
  }

  @override
  List<String> getSpecialistSubscription() {
    final List<String> list = super.getSpecialistSubscription();
    list.add(ObservableUnionImpl.NAME);
    return list;
  }

  @override
  int getObjectObservableDuration() {
    return 5000;
  }
}
