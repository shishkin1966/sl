abstract class Entity {
  Map<String, dynamic> _map = new Map();

  Map<String, dynamic> toMap() {
    return _map;
  }

  dynamic get(String property) {
    return _map[property];
  }

  void set(String property, dynamic value) {
    _map[property] = value;
  }
}
