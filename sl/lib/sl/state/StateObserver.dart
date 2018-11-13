import 'package:sl/sl/state/StateListener.dart';
import 'package:sl/sl/state/Stateable.dart';
import 'package:sl/sl/state/States.dart';

class StateObserver implements Stateable {
  String _state = States.StateCreate;
  StateListener _listener;

  StateObserver(StateListener listener) {
    _listener = listener;
  }

  @override
  String getState() {
    return _state;
  }

  @override
  void setState(String state) {
    _state = state;

    switch (_state) {
      case States.StateCreate:
        onCreate();
        break;

      case States.StateReady:
        onReady();
        break;

      case States.StateDestroy:
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
