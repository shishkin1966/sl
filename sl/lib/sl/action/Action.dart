class Action {
  String _name;
  List<dynamic> _args;

  Action.name(String name) {
    _name = name;
  }

  Action.value(String name, List<dynamic> args) {
    _name = name;
    _args = args;
  }

  String getName() {
    return _name;
  }

  dynamic getValue() {
    if (_args == null) return null;

    return getValueByPos(0);
  }

  dynamic getValueByPos(int pos) {
    if (_args == null) return null;
    if (pos >= _args.length) return null;

    return _args[pos];
  }
}
