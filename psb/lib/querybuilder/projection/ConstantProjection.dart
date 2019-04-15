import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class ConstantProjection extends Projection {
  dynamic _constant;

  ConstantProjection(dynamic constant) {
    this._constant = constant;
  }

  @override
  String build() {
    if (_constant != null)
      return "?";
    else
      return "NULL";
  }

  @override
  List buildParameters() {
    if (_constant != null) {
      return [_constant];
    } else {
      return QueryBuilderUtils.EMPTY_LIST;
    }
  }
}
