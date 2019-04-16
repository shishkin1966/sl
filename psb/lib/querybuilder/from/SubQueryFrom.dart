import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/SqliteQueryBuilder.dart';
import 'package:psb/querybuilder/from/AliasableFrom.dart';

class SubQueryFrom extends AliasableFrom<SubQueryFrom> {
  SqliteQueryBuilder _subQuery;

  SubQueryFrom(SqliteQueryBuilder subQuery) {
    _subQuery = subQuery;
  }

  @override
  String build() {
    String ret = (_subQuery != null ? "(" + _subQuery.build() + ")" : "");

    if (!QueryBuilderUtils.isNullOrWhiteSpace(alias)) ret = ret + " AS " + alias;

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
