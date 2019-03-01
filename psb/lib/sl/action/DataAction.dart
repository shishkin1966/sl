import 'package:psb/sl/action/Action.dart';

class DataAction<T> extends Action {
  T _data;
  String _name;

  DataAction(String name) {
    _name = name;
  }

  T getData() => _data;

  DataAction setData(T value) {
    _data = value;
    return this;
  }

  String getName() => _name;
}
