import 'package:intl/intl.dart';
import 'package:psb/querybuilder/QueryBuilder.dart';
import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/from/From.dart';
import 'package:psb/querybuilder/order/Order.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class SqliteQueryBuilder implements QueryBuilder {
  List<Projection> _projections = new List();
  From _from;
  Criteria _criteria;
  List<Projection> _groupBy = new List();
  List<Order> _orderBy = new List();
  int _skip = 0;
  int _take = 0;
  bool _distinct = false;
  List<SqliteQueryBuilder> _unionQueries = new List();
  bool _unionAll = false;
  DateFormat _dateFormat;
  DateFormat _dateTimeFormat;

  @override
  QueryBuilder distinct() {
    _distinct = true;
    return this;
  }

  @override
  QueryBuilder from(object) {
    if (object == null) return this;

    if (object is QueryBuilder) {
      return from(From.subQuery(object));
    } else if (object is From) {
      _from = object;
      return this;
    } else {
      return from(From.table(object));
    }
  }

  @override
  QueryBuilder groupBy(object) {
    if (object == null) return this;

    if (object is List<Projection>) {
      for (int i = 0; i < object.length; i++) {
        _groupBy.add(object[i]);
      }
      return this;
    } else {
      return groupBy(QueryBuilderUtils.buildColumnProjections(object));
    }
  }

  @override
  QueryBuilder limit(int take) {
    _take = take;
    return this;
  }

  @override
  QueryBuilder limitAll() {
    _take = -1;
    return this;
  }

  @override
  QueryBuilder notDistinct() {
    _distinct = false;
    return this;
  }

  @override
  QueryBuilder offset(int skip) {
    _skip = skip;
    return this;
  }

  @override
  QueryBuilder offsetNone() {
    _skip = -1;
    return this;
  }

  @override
  QueryBuilder orderByAscending(object) {
    if (object == null) return this;

    if (object is List<Projection>) {
      for (int i = 0; i < object.length; i++) {
        _orderBy.add(Order.orderByAscending(object[i]));
      }
      return this;
    } else {
      return orderByAscending(QueryBuilderUtils.buildColumnProjections(object));
    }
  }

  @override
  QueryBuilder orderByAscendingIgnoreCase(object) {
    if (object == null) return this;

    if (object is List<Projection>) {
      for (int i = 0; i < object.length; i++) {
        _orderBy.add(Order.orderByAscendingIgnoreCase(object[i]));
      }
      return this;
    } else {
      return orderByAscendingIgnoreCase(QueryBuilderUtils.buildColumnProjections(object));
    }
  }

  @override
  QueryBuilder orderByDescending(object) {
    if (object == null) return this;

    if (object is List<Projection>) {
      for (int i = 0; i < object.length; i++) {
        _orderBy.add(Order.orderByDescending(object[i]));
      }
      return this;
    } else {
      return orderByDescending(QueryBuilderUtils.buildColumnProjections(object));
    }
  }

  @override
  QueryBuilder orderByDescendingIgnoreCase(object) {
    if (object == null) return this;

    if (object is List<Projection>) {
      for (int i = 0; i < object.length; i++) {
        _orderBy.add(Order.orderByDescendingIgnoreCase(object[i]));
      }
      return this;
    } else {
      return orderByDescendingIgnoreCase(QueryBuilderUtils.buildColumnProjections(object));
    }
  }

  SqliteQueryBuilder clearOrderBy() {
    _orderBy.clear();
    return this;
  }

  @override
  QueryBuilder select(object) {
    if (object == null) return this;

    if (object is List<Projection>) {
      for (int i = 0; i < object.length; i++) {
        _projections.add(object[i]);
      }
      return this;
    } else {
      return select(QueryBuilderUtils.buildColumnProjections(object));
    }
  }

  @override
  QueryBuilder union(QueryBuilder query) {
    (query as SqliteQueryBuilder)._unionAll = false;
    _unionQueries.add(query);
    return this;
  }

  @override
  QueryBuilder unionAll(QueryBuilder query) {
    (query as SqliteQueryBuilder)._unionAll = true;
    _unionQueries.add(query);
    return this;
  }

  @override
  QueryBuilder whereAnd(criteria) {
    if (criteria != null) {
      if (_criteria == null)
        _criteria = criteria;
      else
        _criteria = _criteria.and(criteria);
    }
    return this;
  }

  @override
  QueryBuilder whereOr(criteria) {
    if (criteria != null) {
      if (_criteria == null)
        _criteria = criteria;
      else
        _criteria = _criteria.or(criteria);
    }
    return this;
  }

  @override
  QueryBuilder withDateFormat(format) {
    if (format is DateFormat) {
      _dateFormat = format;
      return this;
    } else {
      return withDateFormat(DateFormat(format));
    }
  }

  @override
  QueryBuilder withDateTimeFormat(format) {
    if (format is DateFormat) {
      _dateTimeFormat = format;
      return this;
    } else {
      return withDateTimeFormat(DateFormat(format));
    }
  }

  @override
  List buildParameters() {
    List ret = new List();
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

      union._orderBy = new List();
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

  void _buildSelectClauseParameters(List ret) {
    for (Projection p in _projections) {
      ret.addAll(p.buildParameters());
    }
  }

  String toDebugSqlString() {
    List parameters = buildParameters();
    String saida = build();

    if (parameters != null) {
      for (Object p in parameters) {
        if (p == null)
          saida = saida.replaceFirst("\\?", "NULL");
        else
          saida = saida.replaceFirst("\\?", _escapeSQLString(p.toString()));
      }
    }

    return saida;
  }

  void _preProcessDateValues(List values) {
    Object value;
    int index = 0;

    while (index < values.length) {
      value = values[index];

      if (value is DateTime) {
        values.remove(index);
        values.insert(index, QueryBuilderUtils.dateToString(value, format: _dateTimeFormat));
      }

      index++;
    }
  }

  String _escapeSQLString(String sqlString) {
    StringBuffer sb = new StringBuffer();
    sb.write('\'');

    if (sqlString.indexOf('\'') != -1) {
      int length = sqlString.length;
      for (int i = 0; i < length; i++) {
        String c = sqlString.substring(i, i);
        if (c == '\'') {
          sb.write('\'');
        }
        sb.write(c);
      }
    } else
      sb.write(sqlString);

    sb.write('\'');
    return sb.toString();
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

      union._orderBy = new List();
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
        if (_groupBy[i] is AliasedProjection) {
          (_groupBy[i] as AliasedProjection).removeAlias();
        }
        sb.write(_groupBy[i].build());
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
    if (from != null) {
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
        sb.write(_projections[i].build());
        if (i < _projections.length - 1) {
          sb.write(", ");
        }
      }
    }
    sb.write(" ");
  }
}
