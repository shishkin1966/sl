import 'package:flutter/widgets.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/state/StateObservable.dart';
import 'package:sl/sl/state/Stateable.dart';
import 'package:sl/sl/state/States.dart';

class LifecycleState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  StateObservable _lifecycle;
  List<Action> _actions = new List<Action>();

  void addObserver(Stateable stateable) {
    _lifecycle.addObserver(stateable);
  }

  String getState() {
    return _lifecycle.getState();
  }

  @override
  void initState() {
    super.initState();

    _lifecycle = new StateObservable();
    _lifecycle.setState(States.StateReady);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _lifecycle.setState(States.StateDestroy);
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _lifecycle.setState(States.StateReady);
        break;

      case AppLifecycleState.inactive:
        //_lifecycle.setState(States.StateNotReady);
        break;

      case AppLifecycleState.paused:
        //_lifecycle.setState(States.StateNotReady);
        break;

      case AppLifecycleState.suspending:
        _lifecycle.setState(States.StateDestroy);
        break;
    }
  }

  void addAction(final Action action) {
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

  void addAction2(final String name, final List<Object> objects) {
    _actions.add(new Action.value(name, objects));
  }

  void _doActions() {
    final List<Action> deleted = new List<Action>();
    for (int i = 0; i < _actions.length; i++) {
      if (getState() != States.StateReady) {
        break;
      }
      doAction(_actions[i]);
      setState(() {});
      deleted.add(_actions[i]);
    }
    for (Action action in deleted) {
      _actions.remove(action);
    }
  }

  void doAction(final Action action) {}

  @override
  Widget build(BuildContext context) {}
}
