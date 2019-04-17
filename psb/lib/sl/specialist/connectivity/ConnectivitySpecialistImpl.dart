import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/connectivity/ConnectivitySpecialist.dart';

class ConnectivitySpecialistImpl extends AbsSpecialist implements ConnectivitySpecialist {
  static const String NAME = "ConnectivitySpecialistImpl";

  bool _isConnected = false;
  StreamSubscription _subscription;

  @override
  String getName() {
    return NAME;
  }

  @override
  int compareTo(other) {
    return (other is ConnectivitySpecialist) ? 0 : 1;
  }

  @override
  bool isConnected() {
    return _isConnected;
  }

  @override
  void onUnRegister() {
    _subscription?.cancel();

    super.onRegister();
  }

  @override
  void onRegister() {
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _setConnectivityState();
    });
  }

  void _setConnectivityState() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _isConnected = false;
    } else {
      _isConnected = true;
    }
  }
}
