import 'package:sl/sl/querybuilder/Criteria.dart';
import 'package:sl/sl/querybuilder/From.dart';
import 'package:sl/sl/querybuilder/Projection.dart';

abstract class QueryBuilder {
  String build();

  QueryBuilder distinct();

  QueryBuilder notDistinct();

  QueryBuilder from(String table);

  QueryBuilder from2(From from);

  QueryBuilder from3(QueryBuilder subQuery);

  QueryBuilder groupBy(List<String> columns);

  QueryBuilder groupBy2(List<Projection> projections);

  QueryBuilder orderByAscending(List<String> columns);

  QueryBuilder orderByAscending2(List<Projection> projections);

  QueryBuilder orderByAscendingIgnoreCase(List<String> columns);

  QueryBuilder orderByAscendingIgnoreCase2(List<Projection> projections);

  QueryBuilder orderByDescending(List<String> columns);

  QueryBuilder orderByDescending2(List<Projection> projections);

  QueryBuilder orderByDescendingIgnoreCase(List<String> columns);

  QueryBuilder orderByDescendingIgnoreCase2(List<Projection> projections);

  QueryBuilder union(QueryBuilder query);

  QueryBuilder unionAll(QueryBuilder query);

  QueryBuilder select(List<String> columns);

  QueryBuilder select2(List<Projection> projections);

  QueryBuilder whereAnd(Criteria criteria);

  QueryBuilder whereOr(Criteria criteria);

  QueryBuilder withDateFormat(String format);

  QueryBuilder withDateTimeFormat(String format);

  QueryBuilder offset(int skip);

  QueryBuilder offsetNone();

  QueryBuilder limit(int limit);

  QueryBuilder limitAll();
}
