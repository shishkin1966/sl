class Action {
  String _name;
  List<Object> _value;

  Action.name(String name) {
    _name = name;
  }

  Action.value(String name, List<Object> value) {
    Action.name(name);
    _value = value;
  }

  String getName() {
    return _name;
  }

  Object getValue() {
    if (_value == null) return null;

    return getValueByPos(0);
  }

  Object getValueByPos(int position) {
    if (_value == null) return null;
    if (position >= _value.length) return null;

    return _value[position];
  }
}
