import 'package:sl/sl/state/State.dart';
import 'package:sl/sl/state/Stateable.dart';

class StateObservable implements Stateable {
  int _state = State.STATE_CREATE;
  List<Stateable> _list = new List<Stateable>();

  @override
  int getState() {
    return _state;
  }

  @override
  void setState(final int state) {
    _state = state;
    for (Stateable stateable in _list) {
      if (stateable != null) {
        stateable.setState(_state);
      }
    }
  }

  void addObserver(final Stateable stateable) {
    if (stateable != null) {
      for (Stateable _stateable in _list) {
        if (_stateable == stateable) {
          return;
        }
      }

      stateable.setState(_state);
      _list.add(stateable);
    }
  }

  void removeObserver(final Stateable stateable) {
    for (Stateable _stateable in _list) {
      if (_stateable == stateable) {
        _list.remove(stateable);
        return;
      }
    }
  }

  void clear() {
    _list.clear();
  }
}
