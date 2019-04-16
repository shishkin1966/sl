import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class BetweenCriteria extends Criteria {
  Projection _projection;
  Object _valueStart;
  Object _valueEnd;

  BetweenCriteria(Projection projection, Object valueStart, Object valueEnd) {
    this._projection = projection;
    this._valueStart = valueStart;
    this._valueEnd = valueEnd;

    if (_projection is AliasedProjection) {
      _projection = (_projection as AliasedProjection).removeAlias();
    }
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
  List buildParameters() {
    List ret = new List();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_valueStart != null) ret.add(_valueStart);

    if (_valueEnd != null) ret.add(_valueEnd);

    return ret;
  }
}
