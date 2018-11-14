import 'package:sl/sl/viewdata/ViewData.dart';

class Action {
  String _name;
  ViewData _arg;

  Action.name(String name) {
    _name = name;
  }

  Action.value(String name, ViewData arg) {
    _name = name;
    _arg = arg;
  }

  String getName() {
    return _name;
  }

  ViewData getValue() {
    return _arg;
  }
}
