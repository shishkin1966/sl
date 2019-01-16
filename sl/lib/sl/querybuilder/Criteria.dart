import 'dart:core';

import 'package:sl/sl/querybuilder/Projection.dart';
import 'package:sl/sl/querybuilder/QueryBuilderUtils.dart';
import 'package:sl/sl/querybuilder/SqliteQueryBuilder.dart';

abstract class Criteria {
  static Criteria isNull(String column) {
    return new BasicCriteria(Projection.column(column), Operators.IS_NULL, null);
  }

  static Criteria notIsNull(String column) {
    return new BasicCriteria(Projection.column(column), Operators.IS_NOT_NULL, null);
  }

  static Criteria isNull2(Projection projection) {
    return new BasicCriteria(projection, Operators.IS_NULL, null);
  }

  static Criteria notIsNull2(Projection projection) {
    return new BasicCriteria(projection, Operators.IS_NOT_NULL, null);
  }

  // Basic criterias
  static Criteria equals(String column, Object value) {
    return new BasicCriteria(Projection.column(column), Operators.EQUALS, value);
  }

  static Criteria notEquals(String column, Object value) {
    return new BasicCriteria(Projection.column(column), Operators.NOT_EQUALS, value);
  }

  static Criteria greaterThan(String column, Object value) {
    return new BasicCriteria(Projection.column(column), Operators.GREATER, value);
  }

  static Criteria lesserThan(String column, Object value) {
    return new BasicCriteria(Projection.column(column), Operators.LESSER, value);
  }

  static Criteria greaterThanOrEqual(String column, Object value) {
    return new BasicCriteria(Projection.column(column), Operators.GREATER_OR_EQUALS, value);
  }

  static Criteria lesserThanOrEqual(String column, Object value) {
    return new BasicCriteria(Projection.column(column), Operators.LESSER_OR_EQUALS, value);
  }

  static Criteria equals2(Projection column, Object value) {
    return new BasicCriteria(column, Operators.EQUALS, value);
  }

  static Criteria notEquals2(Projection column, Object value) {
    return new BasicCriteria(column, Operators.NOT_EQUALS, value);
  }

  static Criteria greaterThan2(Projection column, Object value) {
    return new BasicCriteria(column, Operators.GREATER, value);
  }

  static Criteria lesserThan2(Projection column, Object value) {
    return new BasicCriteria(column, Operators.LESSER, value);
  }

  static Criteria greaterThanOrEqual2(Projection column, Object value) {
    return new BasicCriteria(column, Operators.GREATER_OR_EQUALS, value);
  }

  static Criteria lesserThanOrEqual2(Projection column, Object value) {
    return new BasicCriteria(column, Operators.LESSER_OR_EQUALS, value);
  }

  // String-only criterias
  static Criteria startsWith(String column, String value) {
    return new BasicCriteria(Projection.column(column), Operators.LIKE, value + "%");
  }

  static Criteria notStartsWith(String column, String value) {
    return new BasicCriteria(Projection.column(column), Operators.NOT_LIKE, value + "%");
  }

  static Criteria endsWith(String column, String value) {
    return new BasicCriteria(Projection.column(column), Operators.LIKE, "%" + value);
  }

  static Criteria notEndsWith(String column, String value) {
    return new BasicCriteria(Projection.column(column), Operators.NOT_LIKE, "%" + value);
  }

  static Criteria contains(String column, String value) {
    return new BasicCriteria(Projection.column(column), Operators.LIKE, "%" + value + "%");
  }

  static Criteria notContains(String column, String value) {
    return new BasicCriteria(Projection.column(column), Operators.NOT_LIKE, "%" + value + "%");
  }

  static Criteria startsWith2(Projection column, String value) {
    return new BasicCriteria(column, Operators.LIKE, value + "%");
  }

  static Criteria notStartsWith2(Projection column, String value) {
    return new BasicCriteria(column, Operators.NOT_LIKE, value + "%");
  }

  static Criteria endsWith2(Projection column, String value) {
    return new BasicCriteria(column, Operators.LIKE, "%" + value);
  }

  static Criteria notEndsWith2(Projection column, String value) {
    return new BasicCriteria(column, Operators.NOT_LIKE, "%" + value);
  }

  static Criteria contains2(Projection column, String value) {
    return new BasicCriteria(column, Operators.LIKE, "%" + value + "%");
  }

  static Criteria notContains2(Projection column, String value) {
    return new BasicCriteria(column, Operators.NOT_LIKE, "%" + value + "%");
  }

  AndCriteria and(Criteria criteria) {
    return new AndCriteria(this, criteria);
  }

  OrCriteria or(Criteria criteria) {
    return new OrCriteria(this, criteria);
  }

  // Between
  static Criteria between(String column, Object valueMin, Object valueMax) {
    return new BetweenCriteria(Projection.column(column), valueMin, valueMax);
  }

  static Criteria valueBetween(Object value, String columnMin, String columnMax) {
    return new ValueBetweenCriteria(value, Projection.column(columnMin), Projection.column(columnMax));
  }

  static Criteria between2(Projection column, Object valueMin, Object valueMax) {
    return new BetweenCriteria(column, valueMin, valueMax);
  }

  static Criteria valueBetween2(Object value, Projection columnMin, Projection columnMax) {
    return new ValueBetweenCriteria(value, columnMin, columnMax);
  }

  // Exists
  static Criteria exists(SqliteQueryBuilder subQuery) {
    return new ExistsCriteria(subQuery);
  }

  static Criteria notExists(SqliteQueryBuilder subQuery) {
    return new NotExistsCriteria(subQuery);
  }

  // In
  static Criteria inValue(String column, List<Object> values) {
    return new InCriteria(Projection.column(column), values);
  }

  static Criteria notInValue(String column, List<Object> values) {
    return new NotInCriteria(Projection.column(column), values);
  }

  static Criteria in2(Projection column, List<Object> values) {
    return new InCriteria(column, values);
  }

  static Criteria notIn2(Projection column, List<Object> values) {
    return new NotInCriteria(column, values);
  }

  String build();
  List<Object> buildParameters();
}

class Operators {
  static const String IS_NULL = "IS NULL";
  static const String IS_NOT_NULL = "IS NOT NULL";
  static const String EQUALS = "=";
  static const String NOT_EQUALS = "<>";
  static const String GREATER = ">";
  static const String LESSER = "<";
  static const String GREATER_OR_EQUALS = ">=";
  static const String LESSER_OR_EQUALS = "<=";
  static const String LIKE = "LIKE";
  static const String NOT_LIKE = "NOT LIKE";
}

class BasicCriteria extends Criteria {
  Projection _projection;
  String _operator;
  Object _value;

  BasicCriteria(Projection projection, String operator, Object value) {
    _projection = projection;
    _operator = operator;
    _value = value;

    if (_projection is AliasedProjection) _projection = (projection as AliasedProjection).removeAlias();

    if (value == null) {
      if (Operators.IS_NULL == operator || Operators.EQUALS == operator || Operators.LIKE == operator)
        this._operator = Operators.IS_NULL;
      else
        this._operator = Operators.IS_NOT_NULL;
    }
  }

  @override
  String build() {
    StringBuffer sb = new StringBuffer();

    if (_projection != null) {
      if (_value is DateTime)
        sb.write(_projection.castAsDateTime().build());
      else
        sb.write(_projection.build());
    }

    sb.write(" ");
    sb.write(_operator);
    sb.write(" ");

    if (_value != null) {
      if (_value is AliasedProjection)
        sb.write((_value as AliasedProjection).removeAlias().build());
      else if (_value is Projection)
        sb.write((_value as Projection).build());
      else
        sb.write("?");
    }

    return sb.toString();
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_value != null) ret.add(_value);

    return ret;
  }
}

class AndCriteria extends Criteria {
  Criteria _left;
  Criteria _right;

  AndCriteria(Criteria left, Criteria right) {
    _left = left;
    _right = right;
  }

  @override
  String build() {
    String ret = " AND ";

    if (_left != null) ret = _left.build() + ret;

    if (_right != null) ret = ret + _right.build();

    return "(" + ret.trim() + ")";
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_left != null) ret.addAll(_left.buildParameters());

    if (_right != null) ret.addAll(_right.buildParameters());

    return ret;
  }
}

class OrCriteria extends Criteria {
  Criteria _left;
  Criteria _right;

  OrCriteria(Criteria left, Criteria right) {
    _left = left;
    _right = right;
  }

  @override
  String build() {
    String ret = " OR ";

    if (_left != null) ret = _left.build() + ret;

    if (_right != null) ret = ret + _right.build();

    return "(" + ret.trim() + ")";
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_left != null) ret.addAll(_left.buildParameters());

    if (_right != null) ret.addAll(_right.buildParameters());

    return ret;
  }
}

class BetweenCriteria extends Criteria {
  Projection _projection;
  Object _valueStart;
  Object _valueEnd;

  BetweenCriteria(Projection projection, Object valueStart, Object valueEnd) {
    _projection = projection;
    _valueStart = valueStart;
    _valueEnd = valueEnd;

    if (_projection is AliasedProjection) _projection = (projection as AliasedProjection).removeAlias();
  }

  @override
  String build() {
    StringBuffer sb = new StringBuffer();

    if (_projection != null) sb.write(_projection.build());

    sb.write(" BETWEEN ");
    sb.write((_valueStart != null ? "?" : "NULL"));
    sb.write(" AND ");
    sb.write((_valueEnd != null ? "?" : "NULL"));

    return sb.toString();
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_valueStart != null) ret.add(_valueStart);

    if (_valueEnd != null) ret.add(_valueEnd);

    return ret;
  }
}

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
  List<Object> buildParameters() {
    if (_subQuery != null)
      return _subQuery.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class InCriteria extends Criteria {
  Projection _projection;
  List<Object> _valuesList;

  InCriteria(Projection projection, List<Object> values) {
    _projection = projection;
    _valuesList = values;

    if (_projection is AliasedProjection) _projection = (projection as AliasedProjection).removeAlias();
  }

  @override
  String build() {
    StringBuffer sb = new StringBuffer();

    if (_projection != null) sb.write(_projection.build());

    sb.write(" IN (");

    if (_valuesList != null) {
      if (_valuesList.length <= 0) return "1=0";

      for (int i = 0; i < _valuesList.length; i++) {
        if (_valuesList[i] != null)
          sb.write("?");
        else
          sb.write("NULL");

        if (i < _valuesList.length - 1) {
          sb.write(", ");
        }
      }
    }

    sb.write(")");

    return sb.toString();
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_valuesList != null) {
      for (int i = 0; i < _valuesList.length; i++) {
        if (_valuesList[i] != null) ret.add(_valuesList[i]);
      }
    }
    return ret;
  }
}

class NotExistsCriteria extends ExistsCriteria {
  NotExistsCriteria(SqliteQueryBuilder subQuery) : super(subQuery);

  @override
  String build() {
    return "NOT " + super.build();
  }
}

class NotInCriteria extends Criteria {
  Projection _projection;
  List<Object> _valuesList;

  NotInCriteria(Projection projection, List<Object> values) {
    _projection = projection;
    _valuesList = values;

    if (_projection is AliasedProjection) _projection = (projection as AliasedProjection).removeAlias();
  }

  @override
  String build() {
    StringBuffer sb = new StringBuffer();

    if (_projection != null) sb.write(_projection.build());

    sb.write(" NOT IN (");

    if (_valuesList != null) {
      if (_valuesList.length <= 0) return "1=1";

      for (int i = 0; i < _valuesList.length; i++) {
        if (_valuesList[i] != null)
          sb.write("?");
        else
          sb.write("NULL");

        if (i < _valuesList.length - 1) {
          sb.write(", ");
        }
      }
    }
    sb.write(")");

    return sb.toString();
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_valuesList != null) {
      for (int i = 0; i < _valuesList.length; i++) {
        if (_valuesList[i] != null) ret.add(_valuesList[i]);
      }
    }

    return ret;
  }
}

class ValueBetweenCriteria extends Criteria {
  Object _value;
  Projection _projectionStart;
  Projection _projectionEnd;

  ValueBetweenCriteria(Object value, Projection projectionStart, Projection projectionEnd) {
    _value = value;
    _projectionStart = projectionStart;
    _projectionEnd = projectionEnd;

    if (_projectionStart is AliasedProjection) _projectionStart = (projectionStart as AliasedProjection).removeAlias();

    if (_projectionEnd is AliasedProjection) this._projectionEnd = (projectionEnd as AliasedProjection).removeAlias();
  }

  @override
  String build() {
    StringBuffer sb = new StringBuffer();

    sb.write((_value != null ? "?" : "NULL"));
    sb.write(" BETWEEN ");
    sb.write((_projectionStart != null ? _projectionStart.build() : "NULL"));
    sb.write(" AND ");
    sb.write((_projectionEnd != null ? _projectionEnd.build() : "NULL"));

    return sb.toString();
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_value != null) ret.add(_value);

    if (_projectionStart != null) ret.addAll(_projectionStart.buildParameters());

    if (_projectionEnd != null) ret.addAll(_projectionEnd.buildParameters());

    return ret;
  }
}
