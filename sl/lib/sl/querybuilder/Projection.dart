import 'package:sl/sl/querybuilder/QueryBuilderUtils.dart';
import 'package:sl/sl/querybuilder/SqliteQueryBuilder.dart';

abstract class Projection {
  static ColumnProjection column(String column) {
    return new ColumnProjection(null, column);
  }

  static ColumnProjection columnTable(String table, String column) {
    return new ColumnProjection(table, column);
  }

  // Constant
  static ConstantProjection constant(Object constant) {
    return new ConstantProjection(constant);
  }

  // Aggregate functions
  static AggregateProjection min(String column) {
    return minProjection(Projection.column(column));
  }

  static AggregateProjection max(String column) {
    return maxProjection(Projection.column(column));
  }

  static AggregateProjection sum(String column) {
    return sumProjection(Projection.column(column));
  }

  static AggregateProjection avg(String column) {
    return avgProjection(Projection.column(column));
  }

  static AggregateProjection count(String column) {
    return countProjection(Projection.column(column));
  }

  static AggregateProjection countRows() {
    return countProjection(Projection.column("*"));
  }

  static AggregateProjection minProjection(Projection projection) {
    return new AggregateProjection(projection, Type.MIN);
  }

  static AggregateProjection maxProjection(Projection projection) {
    return new AggregateProjection(projection, Type.MAX);
  }

  static AggregateProjection sumProjection(Projection projection) {
    return new AggregateProjection(projection, Type.SUM);
  }

  static AggregateProjection avgProjection(Projection projection) {
    return new AggregateProjection(projection, Type.AVG);
  }

  static AggregateProjection countProjection(Projection projection) {
    return new AggregateProjection(projection, Type.COUNT);
  }

  // SubQuery
  static SubQueryProjection subQuery(SqliteQueryBuilder subQuery) {
    return new SubQueryProjection(subQuery);
  }

  Projection as(String alias) {
    return new AliasedProjection(this, alias);
  }

  Projection castAsDate() {
    return new CastDateProjection(this);
  }

  Projection castAsDateTime() {
    return new CastDateTimeProjection(this);
  }

  Projection castAsReal() {
    return new CastRealProjection(this);
  }

  Projection castAsInt() {
    return new CastIntProjection(this);
  }

  Projection castAsString() {
    return new CastStringProjection(this);
  }

  String build();

  List<Object> buildParameters();
}

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
  List<Object> buildParameters() {
    return QueryBuilderUtils.EMPTY_LIST;
  }
}

class ConstantProjection extends Projection {
  Object _constant;

  ConstantProjection(Object constant) {
    _constant = constant;
  }

  @override
  String build() {
    if (_constant != null)
      return "?";
    else
      return "NULL";
  }

  @override
  List<Object> buildParameters() {
    if (_constant != null) {
      List<Object> ret = new List<Object>();
      ret.add(_constant);
      return ret;
    } else {
      return QueryBuilderUtils.EMPTY_LIST;
    }
  }
}

class Type {
  static const int MIN = 1;
  static const int MAX = 2;
  static const int SUM = 3;
  static const int AVG = 4;
  static const int COUNT = 5;
}

class AggregateProjection extends Projection {
  Projection _projection;
  int _type;

  AggregateProjection(Projection projection, int type) {
    _projection = projection;
    _type = type;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");

    if (_type == Type.MIN)
      return "MIN(" + ret + ")";
    else if (_type == Type.MAX)
      return "MAX(" + ret + ")";
    else if (_type == Type.SUM)
      return "SUM(" + ret + ")";
    else if (_type == Type.AVG)
      return "AVG(" + ret + ")";
    else if (_type == Type.COUNT)
      return "COUNT(" + ret + ")";
    else
      return ret;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class AliasedProjection extends Projection {
  Projection _projection;
  String _alias;

  AliasedProjection(Projection projection, String alias) {
    _projection = projection;
    _alias = alias;
  }

  @override
  Projection as(String alias) {
    _alias = alias;
    return this;
  }

  @override
  Projection castAsDate() {
    if (_projection != null) _projection = _projection.castAsDate();
    return this;
  }

  @override
  Projection castAsDateTime() {
    if (_projection != null) _projection = _projection.castAsDateTime();
    return this;
  }

  @override
  Projection castAsInt() {
    if (_projection != null) _projection = _projection.castAsInt();
    return this;
  }

  @override
  Projection castAsReal() {
    if (_projection != null) _projection = _projection.castAsReal();
    return this;
  }

  @override
  Projection castAsString() {
    if (_projection != null) _projection = _projection.castAsString();
    return this;
  }

  Projection removeAlias() {
    Projection p = _projection;

    while (p is AliasedProjection) {
      p = (p as AliasedProjection)._projection;
    }

    return p;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return ret + " AS " + _alias;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class CastRealProjection extends Projection {
  Projection _projection;

  CastRealProjection(Projection projection) {
    _projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "CAST(" + ret + " AS REAL)";
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class CastIntProjection extends Projection {
  Projection _projection;

  CastIntProjection(Projection projection) {
    _projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "CAST(" + ret + " AS INTEGER)";
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class CastStringProjection extends Projection {
  Projection _projection;

  CastStringProjection(Projection projection) {
    _projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "CAST(" + ret + " AS TEXT)";
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class CastDateProjection extends Projection {
  Projection _projection;

  CastDateProjection(Projection projection) {
    _projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "DATE(" + ret + ")";
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class CastDateTimeProjection extends Projection {
  Projection _projection;

  CastDateTimeProjection(Projection projection) {
    _projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "DATETIME(" + ret + ")";
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

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
  List<Object> buildParameters() {
    if (_subQuery != null)
      return _subQuery.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
