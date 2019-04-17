import 'dart:io' as Io;

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb/common/StringUtils.dart';

class Log {
  static final Log _log = new Log._internal();
  String _path;

  static Log get instance => _log;

  Log._internal();

  Future init() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      await _setPath();
    }
  }

  Future _setPath() async {
    Io.Directory dir = await getExternalStorageDirectory();
    if (dir != null) {
      _path = dir.path + "/psb_log.txt";
    }
  }

  void w(dynamic object, {String name}) {
    if (object == null) return;
    if (StringUtils.isNullOrEmpty(_path)) return;

    try {
      String sender = StringUtils.isNullOrEmpty(name) ? "" : name + " ";
      if (object is Exception) {
        Io.File(_path).writeAsStringSync(
            DateFormat("dd.MM.yyyy HH:mm:ss").format(DateTime.now()) + " " + sender + object.toString() + "\n",
            mode: Io.FileMode.append);
      } else if (object is String) {
        Io.File(_path).writeAsStringSync(
            DateFormat("dd.MM.yyyy HH:mm:ss").format(DateTime.now()) + " " + sender + object + "\n",
            mode: Io.FileMode.append);
      }
    } catch (e) {}
  }
}
