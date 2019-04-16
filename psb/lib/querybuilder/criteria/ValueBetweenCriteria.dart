import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class ValueBetweenCriteria extends Criteria {
  dynamic _value;
  Projection _projectionStart;
  Projection _projectionEnd;

  ValueBetweenCriteria(dynamic value, Projection projectionStart, Projection projectionEnd) {
    _value = value;
    _projectionStart = projectionStart;
    _projectionEnd = projectionEnd;

    if (_projectionStart is AliasedProjection) _projectionStart = (_projectionStart as AliasedProjection).removeAlias();

    if (_projectionEnd is AliasedProjection) _projectionEnd = (_projectionEnd as AliasedProjection).removeAlias();
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
  List buildParameters() {
    List ret = new List();

    if (_value != null) ret.add(_value);

    if (_projectionStart != null) ret.addAll(_projectionStart.buildParameters());

    if (_projectionEnd != null) ret.addAll(_projectionEnd.buildParameters());

    return ret;
  }
}
