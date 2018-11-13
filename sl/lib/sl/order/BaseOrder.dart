import 'package:sl/sl/order/Order.dart';

class BaseOrder implements Order {
  String _name;
  List<Object> _value = new List();

  BaseOrder.name(String name) {
    _name = name;
  }

  BaseOrder.value(String name, List<Object> value) {
    BaseOrder.name(name);

    _value = value;
  }

  String getName() {
    return _name;
  }

  Object getValue() {
    if (_value == null) return null;
    if (_value.isEmpty) return null;
    return _value[0];
  }

  Object getValue2(int pos) {
    if (_value == null) return null;
    if (_value.isEmpty) return null;
    if (pos >= _value.length) return null;
    return _value[pos];
  }
}
