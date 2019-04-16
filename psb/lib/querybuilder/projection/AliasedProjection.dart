import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class AliasedProjection extends Projection {
  Projection _projection;
  String _alias;

  AliasedProjection(Projection projection, String alias) {
    _projection = projection;
    _alias = alias;
  }

  @override
  Projection as(String alias) {
    _alias = alias;
    return this;
  }

  @override
  Projection castAsDate() {
    if (_projection != null) _projection = _projection.castAsDate();

    return this;
  }

  @override
  Projection castAsDateTime() {
    if (_projection != null) _projection = _projection.castAsDateTime();

    return this;
  }

  @override
  Projection castAsInt() {
    if (_projection != null) _projection = _projection.castAsInt();

    return this;
  }

  @override
  Projection castAsReal() {
    if (_projection != null) _projection = _projection.castAsReal();

    return this;
  }

  @override
  Projection castAsString() {
    if (_projection != null) _projection = _projection.castAsString();

    return this;
  }

  Projection removeAlias() {
    Projection p = _projection;

    while (p is AliasedProjection) {
      p = (p as AliasedProjection)._projection;
    }

    return p;
  }

  @override
  String build() {
    String ret = (_projection != null ? _projection.build() : "");
    return ret + " AS " + _alias;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
