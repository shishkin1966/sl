import 'package:intl/intl.dart';

class QueryBuilderUtils {
  static final List EMPTY_LIST = new List();

  static String toString(dynamic value) {
    if (value == null) return null;

    if (value is String)
      return value;
    else
      return value.toString();
  }

  static String dateToString(DateTime date, {DateFormat format}) {
    if (date == null) return null;

    if (format == null) format = new DateFormat('"yyyy-MM-dd HH:mm:ss');

    try {
      return format.format(date);
    } catch (e) {
      return null;
    }
  }

  static bool isNullOrEmpty(final String string) {
    return (string == null || string.length <= 0);
  }

  static bool isNullOrWhiteSpace(final String string) {
    return (string == null || string.trim().length <= 0);
  }
}
