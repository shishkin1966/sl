import 'package:sl/sl/viewdata/ViewData.dart';

class Order {
  String _name;
  ViewData _args;

  Order.name(String name) {
    _name = name;
  }

  Order.value(String name, ViewData arg) {
    _name = name;
    _args = arg;
  }

  String getName() {
    return _name;
  }

  ViewData getValue() {
    return _args;
  }
}
