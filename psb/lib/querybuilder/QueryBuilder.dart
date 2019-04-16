import 'package:psb/querybuilder/criteria/Criteria.dart';

abstract class QueryBuilder {
  String build();

  List buildParameters();

  QueryBuilder distinct();

  QueryBuilder notDistinct();

  QueryBuilder from(dynamic object);

  QueryBuilder groupBy(dynamic object);

  QueryBuilder orderByAscending(dynamic object);

  QueryBuilder orderByAscendingIgnoreCase(dynamic object);

  QueryBuilder orderByDescending(dynamic object);

  QueryBuilder orderByDescendingIgnoreCase(dynamic object);

  QueryBuilder union(QueryBuilder query);

  QueryBuilder unionAll(QueryBuilder query);

  QueryBuilder select(dynamic object);

  QueryBuilder whereAnd(Criteria criteria);

  QueryBuilder whereOr(Criteria criteria);

  QueryBuilder withDateFormat(dynamic format);

  QueryBuilder withDateTimeFormat(dynamic format);

  QueryBuilder offset(int skip);

  QueryBuilder offsetNone();

  QueryBuilder limit(int limit);

  QueryBuilder limitAll();
}
