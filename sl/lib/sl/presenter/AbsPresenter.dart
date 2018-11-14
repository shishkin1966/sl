import 'package:sl/sl/SL.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/specialist/messager/MessagerUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:sl/sl/state/StateObserver.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/sl/viewdata/ViewData.dart';
import 'package:sl/ui/LifecycleState.dart';

abstract class AbsPresenter<M extends LifecycleState> implements Presenter<M> {
  StateObserver _lifecycle;
  LifecycleState _lifecycleState;

  AbsPresenter(M lifecycleState) {
    _lifecycleState = lifecycleState;
    _lifecycle = new StateObserver(this);
  }

  LifecycleState getLifecycleState() {
    return _lifecycleState;
  }

  @override
  void addAction(String action, ViewData arg) {
    _lifecycleState.addAction(action, arg);
  }

  @override
  void doOrder(String order, ViewData arg) {
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
    return [PresenterUnionImpl.NAME, MessagerUnionImpl.NAME];
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
