import 'dart:core';

import 'package:intl/intl.dart';
import 'package:sl/sl/querybuilder/Criteria.dart';
import 'package:sl/sl/querybuilder/From.dart';
import 'package:sl/sl/querybuilder/Projection.dart';
import 'package:sl/sl/querybuilder/QueryBuilder.dart';

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
  String build() {
    // TODO: implement build
    return null;
  }

  @override
  QueryBuilder distinct() {
    // TODO: implement distinct
    return null;
  }

  @override
  QueryBuilder from(String table) {
    // TODO: implement from
    return null;
  }

  @override
  QueryBuilder fromFrom(from) {
    // TODO: implement fromFrom
    return null;
  }

  @override
  QueryBuilder fromQueryBuilder(QueryBuilder subQuery) {
    // TODO: implement fromQueryBuilder
    return null;
  }

  @override
  QueryBuilder groupBy(List<String> columns) {
    // TODO: implement groupBy
    return null;
  }

  @override
  QueryBuilder groupByProjection(List<Projection> projections) {
    // TODO: implement groupByProjection
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
  QueryBuilder orderByAscending(List<String> columns) {
    // TODO: implement orderByAscending
    return null;
  }

  @override
  QueryBuilder orderByAscendingIgnoreCase(List<String> columns) {
    // TODO: implement orderByAscendingIgnoreCase
    return null;
  }

  @override
  QueryBuilder orderByAscendingIgnoreCaseProjection(List<Projection> projections) {
    // TODO: implement orderByAscendingIgnoreCaseProjection
    return null;
  }

  @override
  QueryBuilder orderByAscendingProjection(List<Projection> projections) {
    // TODO: implement orderByAscendingProjection
    return null;
  }

  @override
  QueryBuilder orderByDescending(List<String> columns) {
    // TODO: implement orderByDescending
    return null;
  }

  @override
  QueryBuilder orderByDescendingIgnoreCase(List<String> columns) {
    // TODO: implement orderByDescendingIgnoreCase
    return null;
  }

  @override
  QueryBuilder orderByDescendingIgnoreCaseProjection(List<Projection> projections) {
    // TODO: implement orderByDescendingIgnoreCaseProjection
    return null;
  }

  @override
  QueryBuilder orderByDescendingProjection(List<Projection> projections) {
    // TODO: implement orderByDescendingProjection
    return null;
  }

  @override
  QueryBuilder select(List<String> columns) {
    // TODO: implement select
    return null;
  }

  @override
  QueryBuilder selectProjection(List<Projection> projections) {
    // TODO: implement selectProjection
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
}
