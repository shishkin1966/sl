import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:sl/sl/AbsSpecialist.dart';
import 'package:sl/sl/specialist/error/ErrorSpecialist.dart';

class ErrorSpecialistImpl extends AbsSpecialist implements ErrorSpecialist {
  static const String NAME = "ErrorSpecialistImpl";

  static final ErrorSpecialistImpl _errorSpecialistImpl = new ErrorSpecialistImpl._internal();

  Logger _logger = Logger(NAME);

  static ErrorSpecialistImpl get instance => _errorSpecialistImpl;

  ErrorSpecialistImpl._internal() {}

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
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        bgcolor: '#ff0000',
        textcolor: '#ffffff');
  }

  @override
  void onErrorMessage(String source, String message) {
    _logger.severe(source, message, StackTrace.current);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        bgcolor: '#ff0000',
        textcolor: '#ffffff');
  }

  @override
  void onErrorDisplay(String source, Exception e, String message) {
    _logger.severe(source, e, StackTrace.current);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        bgcolor: '#ff0000',
        textcolor: '#ffffff');
  }
}
