import 'dart:io' as Io;

import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialist.dart';

class ErrorSpecialistImpl extends AbsSpecialist implements ErrorSpecialist {
  static const String NAME = "ErrorSpecialistImpl";

  static final ErrorSpecialistImpl _errorSpecialistImpl = new ErrorSpecialistImpl._internal();

  Logger _logger = Logger(NAME);
  String _path;

  static ErrorSpecialistImpl get instance => _errorSpecialistImpl;

  ErrorSpecialistImpl._internal();

  @override
  void onRegister() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      await _setPath();
    } else {
      Map<PermissionGroup, PermissionStatus> map =
          await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      if (map[PermissionGroup.storage] == PermissionStatus.granted) {
        await _setPath();
      }
    }
  }

  Future _setPath() async {
    Io.Directory dir = await getExternalStorageDirectory();
    if (dir != null) {
      _path = dir.path + "/psb_log.txt";
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
    _saveLog(e.toString());
  }

  void _saveLog(String text) {
    if (!StringUtils.isNullOrEmpty(_path)) {
      try {
        Io.File(_path).writeAsStringSync(DateFormat("dd.MM.yyyy HH:mm:ss").format(DateTime.now()) + " " + text + "\n",
            mode: Io.FileMode.append);
      } catch (e) {
        SLUtil.uiSpecialist?.showErrorToast(e.toString());
      }
    }
  }

  @override
  void onErrorMessage(String source, String message) {
    _logger.severe(source, message, StackTrace.current);
    SLUtil.uiSpecialist?.showErrorToast(message);
    _saveLog(message);
  }

  @override
  void onErrorDisplay(String source, Exception e, String message) {
    _logger.severe(source, e, StackTrace.current);
    SLUtil.uiSpecialist?.showErrorToast(message);
    _saveLog(e.toString());
  }
}
