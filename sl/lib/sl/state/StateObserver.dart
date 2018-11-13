import 'package:sl/sl/state/State.dart';
import 'package:sl/sl/state/StateListener.dart';
import 'package:sl/sl/state/Stateable.dart';

class StateObserver implements Stateable {
  int _state = State.STATE_CREATE;
  StateListener _listener;

  StateObserver(StateListener listener) {
    _listener = listener;
  }

  @override
  int getState() {
    return _state;
  }

  @override
  void setState(int state) {
    _state = state;

    switch (_state) {
      case State.STATE_CREATE:
        onCreate();
        break;

      case State.STATE_READY:
        onReady();
        break;

      case State.STATE_DESTROY:
        onDestroy();
        break;

      default:
        break;
    }
  }

  void onCreate() {
    if (_listener != null) {
      _listener.onCreate();
    }
  }

  void onReady() {
    if (_listener != null) {
      _listener.onReady();
    }
  }

  void onDestroy() {
    if (_listener != null) {
      _listener.onDestroy();
    }
  }
}
