import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';
import 'package:psb/querybuilder/projection/SqliteQueryBuilder.dart';

class SubQueryProjection extends Projection {
  SqliteQueryBuilder _subQuery;

  SubQueryProjection(SqliteQueryBuilder subQuery) {
    _subQuery = subQuery;
  }

  @override
  String build() {
    if (_subQuery != null)
      return "(" + _subQuery.build() + ")";
    else
      return "";
  }

  @override
  List buildParameters() {
    if (_subQuery != null)
      return _subQuery.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
