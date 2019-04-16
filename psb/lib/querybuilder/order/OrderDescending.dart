import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/order/Order.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class OrderDescending extends Order {
  OrderDescending(Projection projection) : super(projection);

  @override
  String build() {
    String ret = " DESC";

    if (projection != null) ret = projection.build() + ret;

    return ret;
  }

  @override
  List buildParameters() {
    if (projection != null)
      return projection.buildParameters();
    else
      return QueryBuilderUtils.EMPTY_LIST;
  }
}
