import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class CastRealProjection extends Projection {
  Projection _projection;

  CastRealProjection(Projection projection) {
    this._projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "CAST(" + ret + " AS REAL)";
  }

  @override
  List buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
