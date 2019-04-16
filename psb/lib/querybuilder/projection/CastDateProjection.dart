import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class CastDateProjection extends Projection {
  Projection _projection;

  CastDateProjection(Projection projection) {
    _projection = projection;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return "DATE(" + ret + ")";
  }

  @override
  List buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
