import 'dart:async';

import 'package:sl/common/InterruptListener.dart';

class InterruptByTime {
  InterruptListener _listener;
  int _cnt = 0;
  Duration _duration;
  bool _isInterrupt = false;
  Timer _timer;
  String _sender;

  InterruptByTime(final InterruptListener listener, final String sender, int duration) {
    _listener = listener;
    _sender = sender;
    if (duration > 0) {
      _duration = Duration(milliseconds: duration);
    }
  }

  void up() {
    if (!_isInterrupt) {
      _isInterrupt = true;
      _cnt = 0;
      if (_listener != null) {
        _listener.onInterrupt(_sender);
      }
      if (_duration != null) {
        _timer = new Timer(_duration, down);
      } else {
        down();
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

  void cancel() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}
