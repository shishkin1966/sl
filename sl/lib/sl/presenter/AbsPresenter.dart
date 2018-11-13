import 'package:sl/sl/SL.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/StateObserver.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/ui/LifecycleState.dart';

abstract class AbsPresenter<M extends LifecycleState> implements Presenter<M> {
  StateObserver _lifecycle;
  var _lifecycleState;

  AbsPresenter(M lifecycleState) {
    _lifecycleState = lifecycleState;
    _lifecycle = new StateObserver(this);
  }

  M getLifecycleState<M>() {
    return _lifecycleState;
  }

  @override
  void doOrder(Order order) {}

  @override
  void doOrder2(String order, List<Object> objects) {
    doOrder(new Order.value(order, objects));
  }

  @override
  void onCreate() {}

  @override
  void onDestroy() {
    SL.instance.unregisterSubscriber(this);
  }

  @override
  void onOrder(Order order);

  @override
  void onReady() {
    SL.instance.registerSubscriber(this);
  }

  @override
  void read(Message message) {}

  @override
  String getPasport() {
    return getName();
  }

  @override
  List<String> getSpecialistSubscription() {
    // TODO: implement getSpecialistSubscription
  }

  @override
  String getState() {
    return _lifecycle.getState();
  }

  @override
  void setState(String state) {
    _lifecycle.setState(state);
  }

  @override
  bool validate() {
    return validateExt().getData();
  }

  @override
  Result<bool> validateExt() {
    return new Result<bool>(_lifecycle.getState() != States.StateDestroy);
  }
}
