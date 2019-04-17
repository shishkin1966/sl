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
  static AggregateProjection min(dynamic object) {
    if (object is Projection) {
      return new AggregateProjection(object, Type.MIN);
    } else {
      return AggregateProjection(
          Projection.column(object.toString()), Type.MIN);
    }
  }

  static AggregateProjection max(dynamic object) {
    if (object is Projection) {
      return new AggregateProjection(object, Type.MAX);
    } else {
      return new AggregateProjection(
          Projection.column(object.toString()), Type.MAX);
    }
  }

  static AggregateProjection sum(dynamic object) {
    if (object is Projection) {
      return new AggregateProjection(object, Type.SUM);
    } else {
      return new AggregateProjection(
          Projection.column(object.toString()), Type.SUM);
    }
  }

  static AggregateProjection avg(dynamic object) {
    if (object is Projection) {
      return new AggregateProjection(object, Type.AVG);
    } else {
      return new AggregateProjection(
          Projection.column(object.toString()), Type.AVG);
    }
  }

  static AggregateProjection count(dynamic object) {
    if (object is Projection) {
      return new AggregateProjection(object, Type.COUNT);
    } else {
      return new AggregateProjection(
          Projection.column(object.toString()), Type.COUNT);
    }
  }

  static AggregateProjection countRows() {
    return count(Projection.column("*"));
  }

  String build();

  List buildParameters();
}
