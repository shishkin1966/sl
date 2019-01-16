import 'package:sl/sl/querybuilder/Projection.dart';
import 'package:sl/sl/querybuilder/QueryBuilderUtils.dart';

abstract class Order {
  static Order orderByAscending(String column) {
    return new OrderAscending(Projection.column(column));
  }

  static Order orderByDescending(String column) {
    return new OrderDescending(Projection.column(column));
  }

  static Order orderByAscending2(Projection projection) {
    return new OrderAscending(projection);
  }

  static Order orderByDescending2(Projection projection) {
    return new OrderDescending(projection);
  }

  static Order orderByAscendingIgnoreCase(String column) {
    return new OrderAscendingIgnoreCase(Projection.column(column));
  }

  static Order orderByDescendingIgnoreCase(String column) {
    return new OrderDescendingIgnoreCase(Projection.column(column));
  }

  static Order orderByAscendingIgnoreCase2(Projection projection) {
    return new OrderAscendingIgnoreCase(projection);
  }

  static Order orderByDescendingIgnoreCase2(Projection projection) {
    return new OrderDescendingIgnoreCase(projection);
  }

  Projection _projection;

  Order(Projection projection) {
    _projection = projection;

    if (_projection is AliasedProjection) _projection = (_projection as AliasedProjection).removeAlias();
  }

  String build();
  List<Object> buildParameters();
}

class OrderAscending extends Order {
  OrderAscending(Projection projection) : super(projection);

  @override
  String build() {
    String ret = " ASC";

    if (_projection != null) ret = _projection.build() + ret;

    return ret;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class OrderAscendingIgnoreCase extends Order {
  OrderAscendingIgnoreCase(Projection projection) : super(projection);

  @override
  String build() {
    String ret = " COLLATE NOCASE ASC";

    if (_projection != null) ret = _projection.build() + ret;

    return ret;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class OrderDescending extends Order {
  OrderDescending(Projection projection) : super(projection);

  @override
  String build() {
    String ret = " DESC";

    if (_projection != null) ret = _projection.build() + ret;

    return ret;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}

class OrderDescendingIgnoreCase extends Order {
  OrderDescendingIgnoreCase(Projection projection) : super(projection);

  @override
  String build() {
    String ret = " COLLATE NOCASE DESC";

    if (_projection != null) ret = _projection.build() + ret;

    return ret;
  }

  @override
  List<Object> buildParameters() {
    if (_projection != null)
      return _projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
