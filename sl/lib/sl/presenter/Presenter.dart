import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';
import 'package:sl/sl/state/StateListener.dart';
import 'package:sl/ui/LifecycleState.dart';

abstract class Presenter<M extends LifecycleState> implements StateListener, MessagerSubscriber {
  M getLifecycleState<M>();

  void onOrder(Order order);

  void doOrder(Order order);

  void doOrder2(String order, List<Object> objects);
}
