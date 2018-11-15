import 'package:sl/common/StringUtils.dart';

class ExtError {
  final StringBuffer buffer = StringBuffer();

  String owner; // хозяин ошибки

  String get errorText {
    return buffer.toString();
  }

  void addError(final String error) {
    if (!StringUtils.isNullOrEmpty(error)) {
      if (buffer.length > 0) {
        buffer.write("\n");
      }
      buffer.write(error);
    }
  }

  bool hasError() {
    return buffer.length > 0;
  }
}
