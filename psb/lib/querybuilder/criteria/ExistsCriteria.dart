import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/SqliteQueryBuilder.dart';
import 'package:psb/querybuilder/criteria/Criteria.dart';

class ExistsCriteria extends Criteria {
  SqliteQueryBuilder _subQuery;

  ExistsCriteria(SqliteQueryBuilder subQuery) {
    _subQuery = subQuery;
  }

  @override
  String build() {
    String ret = "EXISTS(";

    if (_subQuery != null) ret = ret + _subQuery.build();

    ret = ret + ")";
    return ret;
  }

  @override
  List buildParameters() {
    if (_subQuery != null)
      return _subQuery.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
