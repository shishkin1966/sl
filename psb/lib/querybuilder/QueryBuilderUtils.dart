import 'package:intl/intl.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class QueryBuilderUtils {
  static final List EMPTY_LIST = new List();

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

  static List<Projection> buildColumnProjections(dynamic columns) {
    List<Projection> projections = new List();
    if (columns is List<String>) {
      for (int i = 0; i < columns.length; i++) {
        projections.add(Projection.column(columns[i]));
      }
    } else if (columns is String) {
      projections.add(Projection.column(columns));
    }
    return projections;
  }
}
