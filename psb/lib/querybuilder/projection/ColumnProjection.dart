import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class ColumnProjection extends Projection {
  String _table;
  String _column;

  ColumnProjection(String table, String column) {
    _table = table;
    _column = column;
  }

  @override
  String build() {
    String ret = "";

    if (!QueryBuilderUtils.isNullOrWhiteSpace(_table)) ret = ret + _table + ".";

    if (!QueryBuilderUtils.isNullOrWhiteSpace(_column)) ret = ret + _column;

    return ret;
  }

  @override
  List buildParameters() {
    return QueryBuilderUtils.EMPTY_LIST;
  }
}
