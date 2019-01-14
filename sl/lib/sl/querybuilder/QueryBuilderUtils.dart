import 'package:sl/sl/querybuilder/Projection.dart';

class QueryBuilderUtils {
  static final List<Object> EMPTY_LIST = new List<Object>();

  static String toString(Object value) {
    if (value == null) return null;

    if (value is String)
      return value;
    else
      return value.toString();
  }

  static bool isNullOrEmpty(String string) {
    return (string == null || string.isEmpty);
  }

  static bool isNullOrWhiteSpace(final String string) {
    return (string == null || string.trim().isEmpty);
  }

  static List<Projection> buildColumnProjections(List<String> columns) {
    List<Projection> projections = new List<Projection>();

    for (int i = 0; i < columns.length; i++) {
      projections[i] = Projection.column(columns[i]);
    }
    return projections;
  }
}
