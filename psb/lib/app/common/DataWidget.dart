import 'package:flutter/material.dart';

abstract class DataWidget extends StatefulWidget {
  DataWidget({Key key}) : super(key: key);
}

abstract class DataWidgetState<T> extends State<DataWidget> {
  T _data;

  DataWidgetState(T data) {
    _data = data;
  }

  void onChange(T data) {
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _DataInheritedWidget(
      child: getWidget(),
    );
  }

  Widget getWidget();

  T getData() {
    return _data;
  }
}

class _DataInheritedWidget extends InheritedWidget {
  _DataInheritedWidget({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_DataInheritedWidget old) {
    return true;
  }
}
