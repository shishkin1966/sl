import 'package:logging/logging.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/SL.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialist.dart';
import 'package:psb/sl/specialist/ui/UISpecialistImpl.dart';

class ErrorSpecialistImpl extends AbsSpecialist implements ErrorSpecialist {
  static const String NAME = "ErrorSpecialistImpl";

  static final ErrorSpecialistImpl _errorSpecialistImpl = new ErrorSpecialistImpl._internal();

  Logger _logger = Logger(NAME);

  static ErrorSpecialistImpl get instance => _errorSpecialistImpl;

  ErrorSpecialistImpl._internal();

  @override
  int compareTo(other) {
    return (other is ErrorSpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void onError(String source, Exception e) {
    _logger.severe(source, e, StackTrace.current);
    if (SL.instance.exists(UISpecialistImpl.NAME)) {
      SLUtil.uiSpecialist?.showErrorToast(e.toString());
    }
  }

  @override
  void onErrorMessage(String source, String message) {
    _logger.severe(source, message, StackTrace.current);
    if (SL.instance.exists(UISpecialistImpl.NAME)) {
      SLUtil.uiSpecialist?.showErrorToast(message);
    }
  }

  @override
  void onErrorDisplay(String source, Exception e, String message) {
    _logger.severe(source, e, StackTrace.current);
    if (SL.instance.exists(UISpecialistImpl.NAME)) {
      SLUtil.uiSpecialist?.showErrorToast(message);
    }
  }
}
