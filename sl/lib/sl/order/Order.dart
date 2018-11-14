class Order {
  String _name;
  List<Object> _value = new List();

  Order.name(String name) {
    _name = name;
  }

  Order.value(String name, List<Object> value) {
    _name = name;
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

  Object getValueByPos(int pos) {
    if (_value == null) return null;
    if (_value.isEmpty) return null;
    if (pos >= _value.length) return null;
    return _value[pos];
  }
}
