import 'dart:async';

import 'package:sl/common/InterruptListener.dart';

class InterruptByTime {
  InterruptListener _listener;
  int _cnt = 0;
  Duration _duration = Duration(seconds: 5);
  bool _isInterrupt = false;
  Timer _timer;
  String _sender;

  InterruptByTime(final InterruptListener listener, final String sender) {
    _listener = listener;
    _sender = sender;
  }

  InterruptByTime.delay(final InterruptListener listener, final String sender, final int delay) {
    InterruptByTime(listener, sender);

    if (delay > 0) {
      _duration = Duration(seconds: delay);
    }
  }

  void up() {
    if (!_isInterrupt) {
      _timer = new Timer(_duration, down);
      _isInterrupt = true;
      _cnt = 0;
      if (_listener != null) {
        _listener.onInterrupt(_sender);
      }
    } else {
      _cnt = 1;
    }
  }

  void down() {
    _isInterrupt = false;
    if (_cnt > 0) {
      up();
    }
  }
}
