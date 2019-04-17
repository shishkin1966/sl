import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb/common/Log.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialist.dart';

class ErrorSpecialistImpl extends AbsSpecialist implements ErrorSpecialist {
  static const String NAME = "ErrorSpecialistImpl";

  static final ErrorSpecialistImpl _errorSpecialistImpl = new ErrorSpecialistImpl._internal();

  Logger _logger = Logger(NAME);

  static ErrorSpecialistImpl get instance => _errorSpecialistImpl;

  ErrorSpecialistImpl._internal();

  @override
  void onRegister() async {
    Log.instance.init();
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      Log.instance.init();
    } else {
      Map<PermissionGroup, PermissionStatus> map =
          await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      if (map[PermissionGroup.storage] == PermissionStatus.granted) {
        Log.instance.init();
      }
    }
  }

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
    SLUtil.uiSpecialist?.showErrorToast(e.toString());
    Log.instance.w(e, name: source);
  }

  @override
  void onErrorMessage(String source, String message) {
    _logger.severe(source, message, StackTrace.current);
    SLUtil.uiSpecialist?.showErrorToast(message);
    Log.instance.w(message, name: source);
  }

  @override
  void onErrorDisplay(String source, Exception e, String message) {
    _logger.severe(source, e, StackTrace.current);
    SLUtil.uiSpecialist?.showErrorToast(message);
    Log.instance.w(e, name: source);
  }
}
