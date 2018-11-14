class Order {
  String _name;
  List<dynamic> _args = new List();

  Order.name(String name) {
    _name = name;
  }

  Order.value(String name, List<dynamic> args) {
    _name = name;
    _args = args;
  }

  String getName() {
    return _name;
  }

  dynamic getValue() {
    if (_args == null) return null;
    if (_args.isEmpty) return null;
    return _args[0];
  }

  dynamic getValueByPos(int pos) {
    if (_args == null) return null;
    if (pos >= _args.length) return null;

    return _args[pos];
  }
}
