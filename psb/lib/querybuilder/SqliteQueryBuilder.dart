import 'package:intl/intl.dart';
import 'package:psb/querybuilder/QueryBuilder.dart';
import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/from/From.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

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

  @override
  QueryBuilder distinct() {
    // TODO: implement distinct
    return null;
  }

  @override
  QueryBuilder from(object) {
    // TODO: implement from
    return null;
  }

  @override
  QueryBuilder groupBy(object) {
    // TODO: implement groupBy
    return null;
  }

  @override
  QueryBuilder limit(int limit) {
    // TODO: implement limit
    return null;
  }

  @override
  QueryBuilder limitAll() {
    // TODO: implement limitAll
    return null;
  }

  @override
  QueryBuilder notDistinct() {
    // TODO: implement notDistinct
    return null;
  }

  @override
  QueryBuilder offset(int skip) {
    // TODO: implement offset
    return null;
  }

  @override
  QueryBuilder offsetNone() {
    // TODO: implement offsetNone
    return null;
  }

  @override
  QueryBuilder orderByAscending(object) {
    // TODO: implement orderByAscending
    return null;
  }

  @override
  QueryBuilder orderByAscendingIgnoreCase(object) {
    // TODO: implement orderByAscendingIgnoreCase
    return null;
  }

  @override
  QueryBuilder orderByDescending(object) {
    // TODO: implement orderByDescending
    return null;
  }

  @override
  QueryBuilder orderByDescendingIgnoreCase(object) {
    // TODO: implement orderByDescendingIgnoreCase
    return null;
  }

  @override
  QueryBuilder select(object) {
    // TODO: implement select
    return null;
  }

  @override
  QueryBuilder union(QueryBuilder query) {
    // TODO: implement union
    return null;
  }

  @override
  QueryBuilder unionAll(QueryBuilder query) {
    // TODO: implement unionAll
    return null;
  }

  @override
  QueryBuilder whereAnd(criteria) {
    // TODO: implement whereAnd
    return null;
  }

  @override
  QueryBuilder whereOr(criteria) {
    // TODO: implement whereOr
    return null;
  }

  @override
  QueryBuilder withDateFormat(String format) {
    // TODO: implement withDateFormat
    return null;
  }

  @override
  QueryBuilder withDateTimeFormat(String format) {
    // TODO: implement withDateTimeFormat
    return null;
  }

  @override
  List buildParameters() {
    // TODO: implement buildParameters
    return null;
  }

  @override
  String build() {
    // TODO: implement build
    return null;
  }
}
