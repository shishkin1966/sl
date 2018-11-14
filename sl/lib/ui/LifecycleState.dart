import 'package:flutter/widgets.dart';
import 'package:sl/sl/action/Action.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/StateObservable.dart';
import 'package:sl/sl/state/Stateable.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/sl/viewdata/ViewData.dart';

abstract class LifecycleState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  StateObservable _lifecycle = new StateObservable();
  List<Action> _actions = new List<Action>();
  Presenter _presenter;

  LifecycleState() {
    _presenter = createPresenter();
    addObserver(_presenter);
  }

  Presenter<LifecycleState<StatefulWidget>> createPresenter();

  Presenter getPresenter() {
    return _presenter;
  }

  void addObserver(Stateable stateable) {
    _lifecycle.addObserver(stateable);
  }

  String getState() {
    return _lifecycle.getState();
  }

  @override
  void initState() {
    super.initState();

    _lifecycle.setState(States.StateCreate);

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _lifecycle.setState(States.StateReady));
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
        break;

      case AppLifecycleState.inactive:
        _lifecycle.setState(States.StateNotReady);
        break;

      case AppLifecycleState.paused:
        //_lifecycle.setState(States.StateNotReady);
        break;

      case AppLifecycleState.suspending:
        _lifecycle.setState(States.StateDestroy);
        break;
    }
  }

  void _addAction(final Action action) {
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

  void addAction(final String name, final ViewData arg) {
    _addAction(new Action.value(name, arg));
  }

  void _doActions() {
    final List<Action> deleted = new List<Action>();
    for (int i = 0; i < _actions.length; i++) {
      if (getState() != States.StateReady) {
        break;
      }
      onAction(_actions[i]);
      setState(() {});
      deleted.add(_actions[i]);
    }
    for (Action action in deleted) {
      _actions.remove(action);
    }
  }

  void onAction(final Action action) {}

  @override
  Widget build(BuildContext context) {}
}
