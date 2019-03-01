import 'package:psb/sl/action/Action.dart';

class ApplicationAction extends Action {
  String _name;

  ApplicationAction(String name) {
    _name = name;
  }

  String getName() {
    return _name;
  }
}
