///
/// Действие
///
class Action {
  bool _stateChanged = true;

  Action setStateNonChanged() {
    _stateChanged = false;
    return this;
  }

  bool getStateChanged() {
    return _stateChanged;
  }
}
