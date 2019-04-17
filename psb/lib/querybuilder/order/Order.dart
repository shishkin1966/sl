import 'package:psb/querybuilder/order/OrderAscending.dart';
import 'package:psb/querybuilder/order/OrderAscendingIgnoreCase.dart';
import 'package:psb/querybuilder/order/OrderDescending.dart';
import 'package:psb/querybuilder/order/OrderDescendingIgnoreCase.dart';
import 'package:psb/querybuilder/projection/AliasedProjection.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

abstract class Order {
  Projection _projection;

  Projection get projection {
    return _projection;
  }

  Order(Projection projection) {
    _projection = projection;

    if (_projection is AliasedProjection) {
      _projection = (_projection as AliasedProjection).removeAlias();
    }
  }

  String build();

  List<Object> buildParameters();

  static Order orderByAscending(dynamic object) {
    if (object is Projection) {
      return new OrderAscending(object);
    } else {
      return new OrderAscending(Projection.column(object.toString()));
    }
  }

  static Order orderByDescending(dynamic object) {
    if (object is Projection) {
      return new OrderDescending(object);
    } else {
      return new OrderDescending(Projection.column(object.toString()));
    }
  }

  static Order orderByAscendingIgnoreCase(dynamic object) {
    if (object is Projection) {
      return new OrderAscendingIgnoreCase(object);
    } else {
      return new OrderAscendingIgnoreCase(Projection.column(object.toString()));
    }
  }

  static Order orderByDescendingIgnoreCase(dynamic object) {
    if (object is Projection) {
      return new OrderDescendingIgnoreCase(object);
    } else {
      return new OrderDescendingIgnoreCase(
          Projection.column(object.toString()));
    }
  }
}
