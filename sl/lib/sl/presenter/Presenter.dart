import 'package:sl/sl/MessagerSubscriber.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/state/StateListener.dart';

abstract class Presenter<M> implements StateListener, MessagerSubscriber {
  void setModel<M>(M model);

  M getModel<M>();

  bool isRegister();

  void onStart();

  void onStop();

  void onOrder(Order order);

  void doOrder(Order order);

  void doOrder2(String order, List<Object> objects);
}
