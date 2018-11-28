import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/specialist/messager/MessengerSubscriber.dart';
import 'package:sl/sl/state/StateListener.dart';
import 'package:sl/ui/LifecycleWidgetState.dart';

abstract class Presenter<M extends LifecycleWidgetState> implements StateListener, MessengerSubscriber {
  LifecycleWidgetState getLifecycleState();

  void onAction(Action action);

  void addAction(Action action);
}
