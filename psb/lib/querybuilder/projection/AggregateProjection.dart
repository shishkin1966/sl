import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

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
  List buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class Type {
  static const int MIN = 1;
  static const int MAX = 2;
  static const int SUM = 3;
  static const int AVG = 4;
  static const int COUNT = 5;
}
