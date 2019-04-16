import 'package:psb/querybuilder/projection/AggregateProjection.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/CastDateProjection.dart';
import 'package:psb/querybuilder/projection/CastDateTimeProjection.dart';
import 'package:psb/querybuilder/projection/CastIntProjection.dart';
import 'package:psb/querybuilder/projection/CastRealProjection.dart';
import 'package:psb/querybuilder/projection/CastStringProjection.dart';
import 'package:psb/querybuilder/projection/ColumnProjection.dart';
import 'package:psb/querybuilder/projection/ConstantProjection.dart';

abstract class Projection {
  static ColumnProjection column(String column, {String table}) {
    return new ColumnProjection(table, column);
  }

  Projection as(String alias) {
    return new AliasedProjection(this, alias);
  }

  Projection castAsDateTime() {
    return new CastDateTimeProjection(this);
  }

  Projection castAsDate() {
    return new CastDateProjection(this);
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

  static ConstantProjection constant(dynamic constant) {
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

  String build();

  List buildParameters();
}
