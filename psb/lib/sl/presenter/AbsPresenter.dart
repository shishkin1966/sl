import 'package:psb/sl/SL.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/Message.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:psb/sl/state/StateObserver.dart';
import 'package:psb/sl/state/States.dart';
import 'package:psb/ui/WidgetState.dart';

abstract class AbsPresenter<M extends WidgetState> implements Presenter<M> {
  StateObserver _lifecycle;
  WidgetState _lifecycleState;
  List<Action> _actions = new List<Action>();

  AbsPresenter(M lifecycleState) {
    _lifecycleState = lifecycleState;
    _lifecycle = new StateObserver(this);
  }

  WidgetState getWidget() {
    return _lifecycleState;
  }

  @override
  void addAction(Action action) {
    if (action == null) return;

    final String state = getState();
    switch (state) {
      case States.StateDestroy:
        return;

      case States.StateCreate:
      case States.StateNotReady:
        _actions.add(action);
        return;

      default:
        _actions.add(action);
        _doActions();
        break;
    }
  }

  void _doActions() {
    final List<Action> deleted = new List<Action>();
    for (int i = 0; i < _actions.length; i++) {
      if (getState() != States.StateReady) {
        break;
      }
      onAction(_actions[i]);
      deleted.add(_actions[i]);
    }
    for (Action action in deleted) {
      _actions.remove(action);
    }
  }

  @override
  void onCreate() {}

  @override
  void onDestroy() {
    SL.instance.unregisterSubscriber(this);
  }

  @override
  void onReady() {
    SL.instance.registerSubscriber(this);
  }

  @override
  void read(Message message) {}

  @override
  String getPassport() {
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
