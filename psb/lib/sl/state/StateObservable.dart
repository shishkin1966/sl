import 'package:psb/sl/state/Stateable.dart';
import 'package:psb/sl/state/States.dart';

class StateObservable implements Stateable {
  String _state = States.StateCreate;
  List<Stateable> _list = new List<Stateable>();

  @override
  String getState() {
    return _state;
  }

  @override
  void setState(final String state) {
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
