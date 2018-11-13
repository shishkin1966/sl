import 'package:sl/sl/SL.dart';
import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/model/Model.dart';
import 'package:sl/sl/order/BaseOrder.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/StateObserver.dart';
import 'package:sl/sl/state/States.dart';

abstract class AbsPresenter<M extends Model> implements Presenter<M> {
  var _model;
  StateObserver _lifecycle;

  AbsPresenter(M model) {
    _model = model;
    _lifecycle = new StateObserver(this);
  }

  @override
  void doOrder(Order order) {}

  @override
  void doOrder2(String order, List<Object> objects) {
    doOrder(new BaseOrder.value(order, objects));
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
  void setModel<M>(final M model) {
    _model = model;
  }

  @override
  M getModel<M>() {
    return _model;
  }

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
