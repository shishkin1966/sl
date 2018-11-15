import 'package:sl/common/InterruptListener.dart';

class InterruptByLevel {
  InterruptListener _listener;
  bool _isInterrupt = false;
  String _sender;

  InterruptByLevel(final InterruptListener listener, final String sender) {
    _listener = listener;
    _sender = sender;
  }

  void up() {
    if (!_isInterrupt) {
      _isInterrupt = true;
      if (_listener != null) {
        _listener.onInterrupt(_sender);
      }
    }
  }

  void down() {
    _isInterrupt = false;
  }
}
