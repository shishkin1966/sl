import 'package:flutter/widgets.dart';
import 'package:sl/sl/state/StateObservable.dart';
import 'package:sl/sl/state/Stateable.dart';
import 'package:sl/sl/state/States.dart';

class LifecycleState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  StateObservable _lifecycle;

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

  @override
  Widget build(BuildContext context) {}
}
