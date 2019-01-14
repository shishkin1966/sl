import 'package:sl/sl/querybuilder/Projection.dart';

abstract class QueryBuilder {
  String build();

  QueryBuilder distinct();

  QueryBuilder notDistinct();

  QueryBuilder from(String table);

  QueryBuilder fromFrom(From from);

  QueryBuilder fromQueryBuilder(QueryBuilder subQuery);

  QueryBuilder groupBy(List<String> columns);

  QueryBuilder groupByProjection(List<Projection> projections);

  QueryBuilder orderByAscending(List<String> columns);

  QueryBuilder orderByAscendingProjection(List<Projection> projections);

  QueryBuilder orderByAscendingIgnoreCase(List<String> columns);

  QueryBuilder orderByAscendingIgnoreCaseProjection(List<Projection> projections);

  QueryBuilder orderByDescending(List<String> columns);

  QueryBuilder orderByDescendingProjection(List<Projection> projections);

  QueryBuilder orderByDescendingIgnoreCase(List<String> columns);

  QueryBuilder orderByDescendingIgnoreCaseProjection(List<Projection> projections);

  QueryBuilder union(QueryBuilder query);

  QueryBuilder unionAll(QueryBuilder query);

  QueryBuilder select(List<String> columns);

  QueryBuilder selectProjection(List<Projection> projections);

  QueryBuilder whereAnd(Criteria criteria);

  QueryBuilder whereOr(Criteria criteria);

  QueryBuilder withDateFormat(String format);

  QueryBuilder withDateTimeFormat(String format);

  QueryBuilder offset(int skip);

  QueryBuilder offsetNone();

  QueryBuilder limit(int limit);

  QueryBuilder limitAll();
}
