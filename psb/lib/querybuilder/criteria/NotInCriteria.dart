import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class NotInCriteria extends Criteria {
  Projection _projection;
  List _valuesList;

  NotInCriteria(Projection projection, List values) {
    _projection = projection;
    _valuesList = values;

    if (_projection is AliasedProjection) _projection = (_projection as AliasedProjection).removeAlias();
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
  List buildParameters() {
    List ret = new List();

    if (_projection != null) ret.addAll(_projection.buildParameters());

    if (_valuesList != null) {
      for (int i = 0; i < _valuesList.length; i++) {
        if (_valuesList[i] != null) ret.add(_valuesList[i]);
      }
    }

    return ret;
  }
}
