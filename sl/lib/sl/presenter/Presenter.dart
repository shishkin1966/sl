import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/specialist/messager/MessengerSubscriber.dart';
import 'package:sl/sl/state/StateListener.dart';
import 'package:sl/sl/statechange/StateChange.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

abstract class Presenter<M extends LifecycleWidgetState> implements StateListener, MessengerSubscriber {
  LifecycleWidgetState getLifecycleState();

  void onOrder(Order order);

  void doOrder(String order, StateChange arg);

  void addAction(String action, StateChange arg);
}
