import 'package:sl/sl/statechange/StateChange.dart';

class Order {
  String _name;
  StateChange _args;

  Order.name(String name) {
    _name = name;
  }

  Order.value(String name, StateChange arg) {
    _name = name;
    _args = arg;
  }

  String getName() {
    return _name;
  }

  StateChange getValue() {
    return _args;
  }
}
