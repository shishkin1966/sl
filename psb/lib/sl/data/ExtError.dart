import 'package:psb/common/StringUtils.dart';

///
/// Расширенная ошибка
///
class ExtError {
  final StringBuffer _buffer = StringBuffer();
  String owner; // хозяин ошибки

  String get errorText {
    return _buffer.toString();
  }

  void addError(final String error) {
    if (!StringUtils.isNullOrEmpty(error)) {
      if (_buffer.length > 0) {
        _buffer.write("\n");
      }
      _buffer.write(error);
    }
  }

  bool hasError() {
    return _buffer.length > 0;
  }
}
