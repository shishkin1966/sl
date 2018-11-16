import 'package:sl/sl/SL.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:sl/sl/state/StateObserver.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/sl/statechange/StateChange.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

abstract class AbsPresenter<M extends LifecycleWidgetState> implements Presenter<M> {
  StateObserver _lifecycle;
  LifecycleWidgetState _lifecycleState;

  AbsPresenter(M lifecycleState) {
    _lifecycleState = lifecycleState;
    _lifecycle = new StateObserver(this);
  }

  LifecycleWidgetState getLifecycleState() {
    return _lifecycleState;
  }

  @override
  void addAction(String action, StateChange arg) {
    _lifecycleState.addAction(action, arg);
  }

  @override
  void doOrder(String order, StateChange arg) {
    onOrder(new Order.value(order, arg));
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
    return [PresenterUnionImpl.NAME, MessengerUnionImpl.NAME];
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
