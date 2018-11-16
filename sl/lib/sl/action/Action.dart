import 'package:sl/sl/statechange/StateChange.dart';

class Action {
  String _name;
  StateChange _arg;

  Action.name(String name) {
    _name = name;
  }

  Action.value(String name, StateChange arg) {
    _name = name;
    _arg = arg;
  }

  String getName() {
    return _name;
  }

  StateChange getValue() {
    return _arg;
  }
}
