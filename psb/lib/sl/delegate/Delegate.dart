import 'dart:async';

class Delegate<T> {
  final _handlers = <void Function(T e)>[];

  void addHandler(void Function(T e) handler) => _handlers.add(handler);

  void dispatch(T x) => _handlers.forEach((h) => h(x));
}

class EventHandler<T> {
  final _onEvent = new StreamController<T>.broadcast(sync: true);

  Stream<T> get onEvent => _onEvent.stream;

  void emit(T value) => _onEvent.add(value);
}
