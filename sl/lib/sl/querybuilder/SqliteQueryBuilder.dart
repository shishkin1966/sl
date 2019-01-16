import 'dart:core';

import 'package:intl/intl.dart';
import 'package:sl/sl/querybuilder/Criteria.dart';
import 'package:sl/sl/querybuilder/From.dart';
import 'package:sl/sl/querybuilder/Order.dart';
import 'package:sl/sl/querybuilder/Projection.dart';
import 'package:sl/sl/querybuilder/QueryBuildConfiguration.dart';
import 'package:sl/sl/querybuilder/QueryBuilder.dart';
import 'package:sl/sl/querybuilder/QueryBuilderUtils.dart';

class SqliteQueryBuilder implements QueryBuilder {
  List<Projection> _projections;
  From _from;
  Criteria _criteria;
  List<Projection> _groupBy;
  List<Order> _orderBy;
  int _skip;
  int _take;
  bool _distinct;
  List<SqliteQueryBuilder> _unionQueries;
  bool _unionAll;
  DateFormat _dateFormat;
  DateFormat _dateTimeFormat;

  SqliteQueryBuilder.dateformat(DateFormat dateFormat, DateFormat dateTimeFormat) {
    _projections = new List<Projection>();
    _from = null;
    _criteria = null;
    _groupBy = new List<Projection>();
    _orderBy = new List<Order>();
    _skip = -1;
    _take = -1;
    _distinct = false;
    _unionQueries = new List<SqliteQueryBuilder>();
    _unionAll = false;
    _dateFormat = dateFormat;
    _dateTimeFormat = dateTimeFormat;
  }

  SqliteQueryBuilder.string(String dateFormat, String dateTimeFormat)
      : this.dateformat(new DateFormat(dateFormat), new DateFormat(dateTimeFormat));

  SqliteQueryBuilder()
      : this.dateformat(
            QueryBuildConfiguration.instance.getDateFormat(), QueryBuildConfiguration.instance.getDateTimeFormat());

  @override
  SqliteQueryBuilder withDateFormat(String format) {
    return withDateFormat2(new DateFormat(format));
  }

  SqliteQueryBuilder withDateFormat2(DateFormat format) {
    _dateFormat = format;
    return this;
  }

  @override
  SqliteQueryBuilder withDateTimeFormat(String format) {
    return withDateTimeFormat2(new DateFormat(format));
  }

  SqliteQueryBuilder withDateTimeFormat2(DateFormat format) {
    _dateTimeFormat = format;
    return this;
  }

  @override
  SqliteQueryBuilder select(List<String> columns) {
    if (columns == null) return this;

    return select2(QueryBuilderUtils.buildColumnProjections(columns));
  }

  @override
  SqliteQueryBuilder select2(List<Projection> projections) {
    if (projections == null) return this;

    for (int i = 0; i < projections.length; i++) {
      _projections.add(projections[i]);
    }

    return this;
  }

  @override
  SqliteQueryBuilder from2(From from) {
    if (from != null) _from = from;

    return this;
  }

  @override
  SqliteQueryBuilder from(String table) {
    return from2(From.table(table));
  }

  @override
  SqliteQueryBuilder from3(QueryBuilder subQuery) {
    return from2(From.subQuery(subQuery));
  }

  @override
  SqliteQueryBuilder whereAnd(Criteria criteria) {
    if (criteria != null) {
      if (_criteria == null)
        _criteria = criteria;
      else
        _criteria = _criteria.and(criteria);
    }

    return this;
  }

  @override
  SqliteQueryBuilder whereOr(Criteria criteria) {
    if (criteria != null) {
      if (_criteria == null)
        _criteria = criteria;
      else
        _criteria = _criteria.or(criteria);
    }

    return this;
  }

  @override
  SqliteQueryBuilder groupBy(List<String> columns) {
    if (columns == null) return this;

    return groupBy2(QueryBuilderUtils.buildColumnProjections(columns));
  }

  @override
  SqliteQueryBuilder groupBy2(List<Projection> projections) {
    if (projections == null) return this;

    for (int i = 0; i < projections.length; i++) {
      _groupBy.add(projections[i]);
    }

    return this;
  }

  SqliteQueryBuilder clearGroupBy() {
    _groupBy.clear();
    return this;
  }

  @override
  SqliteQueryBuilder orderByAscending(List<String> columns) {
    if (columns == null) return this;

    return orderByAscending2(QueryBuilderUtils.buildColumnProjections(columns));
  }

  @override
  SqliteQueryBuilder orderByAscending2(List<Projection> projections) {
    if (projections == null) return this;

    for (int i = 0; i < projections.length; i++) {
      _orderBy.add(Order.orderByAscending2(projections[i]));
    }

    return this;
  }

  @override
  SqliteQueryBuilder orderByDescending(List<String> columns) {
    if (columns == null) return this;

    return orderByDescending2(QueryBuilderUtils.buildColumnProjections(columns));
  }

  @override
  SqliteQueryBuilder orderByDescending2(List<Projection> projections) {
    if (projections == null) return this;

    for (int i = 0; i < projections.length; i++) {
      _orderBy.add(Order.orderByDescending2(projections[i]));
    }

    return this;
  }

  @override
  SqliteQueryBuilder orderByAscendingIgnoreCase(List<String> columns) {
    if (columns == null) return this;

    return orderByAscendingIgnoreCase2(QueryBuilderUtils.buildColumnProjections(columns));
  }

  @override
  SqliteQueryBuilder orderByAscendingIgnoreCase2(List<Projection> projections) {
    if (projections == null) return this;

    for (int i = 0; i < projections.length; i++) {
      _orderBy.add(Order.orderByAscendingIgnoreCase2(projections[i]));
    }

    return this;
  }

  @override
  SqliteQueryBuilder orderByDescendingIgnoreCase(List<String> columns) {
    if (columns == null) return this;

    return orderByDescendingIgnoreCase2(QueryBuilderUtils.buildColumnProjections(columns));
  }

  @override
  SqliteQueryBuilder orderByDescendingIgnoreCase2(List<Projection> projections) {
    if (projections == null) return this;

    for (int i = 0; i < projections.length; i++) {
      _orderBy.add(Order.orderByDescendingIgnoreCase2(projections[i]));
    }

    return this;
  }

  SqliteQueryBuilder clearOrderBy() {
    _orderBy.clear();
    return this;
  }

  @override
  SqliteQueryBuilder offset(int skip) {
    _skip = skip;
    return this;
  }

  @override
  SqliteQueryBuilder offsetNone() {
    _skip = -1;
    return this;
  }

  @override
  SqliteQueryBuilder limit(int take) {
    _take = take;
    return this;
  }

  @override
  SqliteQueryBuilder limitAll() {
    _take = -1;
    return this;
  }

  @override
  SqliteQueryBuilder distinct() {
    _distinct = true;
    return this;
  }

  @override
  SqliteQueryBuilder notDistinct() {
    _distinct = false;
    return this;
  }

  @override
  SqliteQueryBuilder union(QueryBuilder query) {
    (query as SqliteQueryBuilder)._unionAll = false;
    _unionQueries.add(query as SqliteQueryBuilder);

    return this;
  }

  @override
  SqliteQueryBuilder unionAll(QueryBuilder query) {
    (query as SqliteQueryBuilder)._unionAll = true;
    _unionQueries.add(query as SqliteQueryBuilder);

    return this;
  }

  void _buildSkipClause(StringBuffer sb) {
    if (_skip > 0) {
      sb.write(" OFFSET ");
      sb.write(_skip);
    }
  }

  void _buildTakeClause(StringBuffer sb) {
    if (_take > 0) {
      sb.write(" LIMIT ");
      sb.write(_take);
    }
  }

  void _buildOrderByClause(StringBuffer sb) {
    if (_orderBy.length > 0) {
      sb.write(" ORDER BY ");

      for (int i = 0; i < _orderBy.length; i++) {
        sb.write(_orderBy[i].build());
        if (i < _orderBy.length - 1) {
          sb.write(", ");
        }
      }
    }
  }

  void _buildUnionClause(StringBuffer sb) {
    List<Order> oldOrderBy;
    int oldSkip;
    int oldTake;

    for (SqliteQueryBuilder union in _unionQueries) {
      sb.write(union._unionAll ? " UNION ALL " : " UNION ");

      oldOrderBy = union._orderBy;
      oldSkip = union._skip;
      oldTake = union._take;

      union._orderBy = new List<Order>();
      union._skip = -1;
      union._take = -1;

      sb.write(union.build());

      union._orderBy = oldOrderBy;
      union._skip = oldSkip;
      union._take = oldTake;
    }
  }

  void _buildGroupByClause(StringBuffer sb) {
    if (_groupBy.length > 0) {
      sb.write(" GROUP BY ");

      for (int i = 0; i < _groupBy.length; i++) {
        Projection p = _groupBy[i];
        if (p is AliasedProjection) p = (p as AliasedProjection).removeAlias();

        sb.write(p.build());
        if (i < _groupBy.length - 1) {
          sb.write(", ");
        }
      }
    }
  }

  void _buildWhereClause(StringBuffer sb) {
    if (_criteria != null) {
      sb.write("WHERE ");
      sb.write(_criteria.build());
    }
  }

  void _buildFromClause(StringBuffer sb) {
    if (_from != null) {
      sb.write("FROM ");
      sb.write(_from.build());
      sb.write(" ");
    }
  }

  void _buildSelectClause(StringBuffer sb) {
    sb.write("SELECT ");

    if (_distinct) sb.write("DISTINCT ");

    if (_projections.length <= 0) {
      sb.write("*");
    } else {
      for (int i = 0; i < _projections.length; i++) {
        Projection p = _projections[i];
        sb.write(p.build());
        if (i < _projections.length - 1) {
          sb.write(", ");
        }
      }
    }
    sb.write(" ");
  }

  @override
  String build() {
    StringBuffer sb = new StringBuffer();

    _buildSelectClause(sb);

    _buildFromClause(sb);

    _buildWhereClause(sb);

    _buildGroupByClause(sb);

    _buildUnionClause(sb);

    _buildOrderByClause(sb);

    _buildTakeClause(sb);

    _buildSkipClause(sb);

    return sb.toString();
  }

  void _buildSelectClauseParameters(List<Object> ret) {
    for (Projection p in _projections) {
      ret.addAll(p.buildParameters());
    }
  }

  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();
    List<Order> oldOrderBy;
    int oldSkip;
    int oldTake;

    _buildSelectClauseParameters(ret);

    if (_from != null) ret.addAll(_from.buildParameters());

    if (_criteria != null) ret.addAll(_criteria.buildParameters());

    for (Projection p in _groupBy) {
      ret.addAll(p.buildParameters());
    }

    for (SqliteQueryBuilder union in _unionQueries) {
      oldOrderBy = union._orderBy;
      oldSkip = union._skip;
      oldTake = union._take;

      union._orderBy = new List<Order>();
      union._skip = -1;
      union._take = -1;

      ret.addAll(union.buildParameters());

      union._orderBy = oldOrderBy;
      union._skip = oldSkip;
      union._take = oldTake;
    }

    for (Order o in _orderBy) {
      ret.addAll(o.buildParameters());
    }

    _preProcessDateValues(ret);
    return ret;
  }

  void _preProcessDateValues(List<Object> values) {
    Object value;
    int index = 0;

    while (index < values.length) {
      value = values[index];

      if (value is DateTime) {
        values.remove(index);
        values.insert(index, QueryBuilderUtils.dateToString(value as DateTime, _dateTimeFormat));
      }

      index++;
    }
  }
}
