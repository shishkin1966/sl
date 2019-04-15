import 'dart:core';

import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class BasicCriteria extends Criteria {
  Projection _projection;
  String _operator;
  Object _value;

  BasicCriteria(Projection projection, String operator, Object value) {
    _projection = projection;
    _operator = operator;
    _value = value;

    if (_projection is AliasedProjection) _projection = (_projection as AliasedProjection).removeAlias();

    if (value == null) {
      if (Operators.IS_NULL == operator || Operators.EQUALS == operator || Operators.LIKE == operator)
        _operator = Operators.IS_NULL;
      else
        _operator = Operators.IS_NOT_NULL;
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
  List buildParameters() {
    List ret = new List();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_value != null) ret.add(_value);

    return ret;
  }
}

class Operators {
  static final String IS_NULL = "IS NULL";
  static final String IS_NOT_NULL = "IS NOT NULL";
  static final String EQUALS = "=";
  static final String NOT_EQUALS = "<>";
  static final String GREATER = ">";
  static final String LESSER = "<";
  static final String GREATER_OR_EQUALS = ">=";
  static final String LESSER_OR_EQUALS = "<=";
  static final String LIKE = "LIKE";
  static final String NOT_LIKE = "NOT LIKE";
}
