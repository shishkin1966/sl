import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/state/StateObservable.dart';
import 'package:psb/sl/state/Stateable.dart';
import 'package:psb/sl/state/States.dart';

abstract class WidgetState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  StateObservable _lifecycle = new StateObservable();
  List<Action> _actions = new List<Action>();
  Presenter _presenter;
  StreamSubscription _subscription;
  SnackBar snackbar;
  List<String> _visibled = new List();
  GlobalKey _scaffoldKey = new GlobalKey();
  Timer _debounce;

  WidgetState() {
    _presenter = createPresenter();
    addObserver(_presenter);
  }

  Presenter<WidgetState<StatefulWidget>> createPresenter();

  Presenter getPresenter() {
    return _presenter;
  }

  void addObserver(Stateable stateable) {
    _lifecycle.addObserver(stateable);
  }

  String getState() {
    return _lifecycle.getState();
  }

  @override
  void initState() {
    super.initState();

    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setConnectivityState();
    });

    _lifecycle.setState(States.StateCreate);

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setConnectivityState();
      _lifecycle.setState(States.StateReady);
      _doActions();
    });
  }

  void setConnectivityState() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // I am not connected
      showConnectivitySnackBar();
    } else {
      // I am connected
      hideConnectivitySnackBar();
    }
  }

  void showConnectivitySnackBar() {
    ScaffoldState state = getScaffoldState();
    if (snackbar != null) {
      getScaffoldState().removeCurrentSnackBar();
      snackbar = null;
    }
    if (snackbar == null) {
      snackbar = SLUtil.getUISpecialist()
          .getNoConnectivitySnackBar(SLUtil.getString(getScaffoldState().context, 'no_connectivity'));
      state.showSnackBar(snackbar);
    }
  }

  void hideConnectivitySnackBar() {
    ScaffoldState state = getScaffoldState();
    if (snackbar != null) {
      state.removeCurrentSnackBar();
    }
    snackbar = null;
  }

  @override
  void dispose() {
    _subscription.cancel();
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _lifecycle.setState(States.StateDestroy);
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;

      case AppLifecycleState.inactive:
        //_lifecycle.setState(States.StateNotReady);
        break;

      case AppLifecycleState.paused:
        //_lifecycle.setState(States.StateNotReady);
        break;

      case AppLifecycleState.suspending:
        _lifecycle.setState(States.StateDestroy);
        break;
    }
  }

  void addAction(Action action) {
    if (action == null) return;

    final String state = getState();
    switch (state) {
      case States.StateDestroy:
        return;

      case States.StateCreate:
      case States.StateNotReady:
        _actions.add(action);
        return;

      default:
        _actions.add(action);
        _doActions();
        break;
    }
  }

  void addActionDebounced(final Action action, int duration) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: duration), () {
      addAction(action);
    });
  }

  void addActions(List<Action> actions) {
    if (actions == null) return;

    final String state = getState();
    switch (state) {
      case States.StateDestroy:
        return;

      case States.StateCreate:
      case States.StateNotReady:
        _actions.addAll(actions);
        return;

      default:
        _actions.addAll(actions);
        _doActions();
        break;
    }
  }

  void _doActions() {
    final List<Action> deleted = new List<Action>();
    for (int i = 0; i < _actions.length; i++) {
      if (getState() != States.StateReady) {
        break;
      }
      onAction(_actions[i]);
      if (_actions[i].getStateChanged()) {
        setState(() {});
      }
      deleted.add(_actions[i]);
    }
    for (Action action in deleted) {
      _actions.remove(action);
    }
  }

  void onAction(final Action action) {}

  @override
  Widget build(BuildContext context);

  void setVisible(String widget) {
    if (!_visibled.contains(widget)) {
      _visibled.add(widget);
    }
  }

  void setUnvisible(String widget) {
    if (_visibled.contains(widget)) {
      _visibled.remove(widget);
    }
  }

  bool getVisible(String widget) {
    return _visibled.contains(widget);
  }

  GlobalKey getScaffoldKey() {
    return _scaffoldKey;
  }

  ScaffoldState getScaffoldState() {
    return _scaffoldKey.currentState as ScaffoldState;
  }
}
