import 'package:sl/sl/querybuilder/Criteria.dart';
import 'package:sl/sl/querybuilder/Projection.dart';
import 'package:sl/sl/querybuilder/QueryBuilderUtils.dart';
import 'package:sl/sl/querybuilder/SqliteQueryBuilder.dart';

abstract class From {
  String build();

  List<Object> buildParameters();

  static TableFrom table(String table) {
    return new TableFrom(table);
  }

  static SubQueryFrom subQuery(SqliteQueryBuilder subQuery) {
    return new SubQueryFrom(subQuery);
  }

  PartialJoin innerJoin(String table) {
    return innerJoinFrom(From.table(table));
  }

  PartialJoin innerJoinBuilder(SqliteQueryBuilder subQuery) {
    return innerJoin(From.subQuery(subQuery));
  }

  PartialJoin innerJoinFrom(From table) {
    return new PartialJoin(this, table, "INNER JOIN");
  }

  PartialJoin leftJoin(String table) {
    return leftJoinFrom(From.table(table));
  }

  PartialJoin leftJoinBuilder(SqliteQueryBuilder subQuery) {
    return leftJoin(From.subQuery(subQuery));
  }

  PartialJoin leftJoinFrom(From table) {
    return new PartialJoin(this, table, "LEFT JOIN");
  }
}

class PartialJoin {
  String _joinType;
  From _left;
  From _right;

  PartialJoin(From left, From right, String joinType) {
    _joinType = joinType;
    _left = left;
    _right = right;
  }

  JoinFrom on(String leftColumn, String rightColumn) {
    return onCriteria(Criteria.equalsProjection(Projection.column(leftColumn), Projection.column(rightColumn)));
  }

  JoinFrom onCriteria(Criteria criteria) {
    return new JoinFrom(_left, _right, _joinType, criteria);
  }
}

abstract class AliasableFrom<T> extends From {
  String alias;

  T as(String alias) {
    this.alias = alias;
    return this as T;
  }
}

class JoinFrom extends From {
  From _left;
  From _right;
  String _joinType;
  Criteria _criteria;

  JoinFrom(From left, From right, String joinType, Criteria criteria) {
    _left = left;
    _right = right;
    _joinType = joinType;
    _criteria = criteria;
  }

  JoinFrom onOr(String leftColumn, String rightColumn) {
    return onOrCriteria(Criteria.equalsProjection(Projection.column(leftColumn), Projection.column(rightColumn)));
  }

  JoinFrom onAnd(String leftColumn, String rightColumn) {
    return onAndCriteria(Criteria.equalsProjection(Projection.column(leftColumn), Projection.column(rightColumn)));
  }

  JoinFrom onAndCriteria(Criteria criteria) {
    _criteria = (_criteria != null ? _criteria.and(criteria) : criteria);
    return this;
  }

  JoinFrom onOrCriteria(Criteria criteria) {
    _criteria = (_criteria != null ? _criteria.or(criteria) : criteria);
    return this;
  }

  @override
  String build() {
    String leftSide = (_left != null ? _left.build() : "");
    String rightSide = (_right != null ? _right.build() : "");
    String joinCriteria = (_criteria != null ? _criteria.build() : "");

    return "(" + leftSide + " " + _joinType + " " + rightSide + " ON " + joinCriteria + ")";
  }

  @override
  List<Object> buildParameters() {
    List<Object> ret = new List<Object>();

    if (_left != null) ret.addAll(_left.buildParameters());

    if (_right != null) ret.addAll(_right.buildParameters());

    if (_criteria != null) ret.addAll(_criteria.buildParameters());

    return ret;
  }
}

class TableFrom extends AliasableFrom<TableFrom> {
  String _table;

  TableFrom(String table) {
    _table = table;
  }

  @override
  String build() {
    String ret = (!QueryBuilderUtils.isNullOrWhiteSpace(_table) ? _table : "");

    if (!QueryBuilderUtils.isNullOrWhiteSpace(alias)) ret = ret + " AS " + alias;

    return ret;
  }

  @override
  List<Object> buildParameters() {
    return QueryBuilderUtils.EMPTY_LIST;
  }
}
