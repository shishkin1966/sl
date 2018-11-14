import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';
import 'package:sl/sl/state/StateListener.dart';
import 'package:sl/sl/viewdata/ViewData.dart';
import 'package:sl/ui/LifecycleState.dart';

abstract class Presenter<M extends LifecycleState> implements StateListener, MessagerSubscriber {
  LifecycleState getLifecycleState();

  void onOrder(Order order);

  void doOrder(String order, ViewData arg);

  void addAction(String action, ViewData arg);
}
