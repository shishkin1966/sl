import 'package:psb/querybuilder/QueryBuilderUtils.dart';
import 'package:psb/querybuilder/from/AliasableFrom.dart';

class TableFrom extends AliasableFrom<TableFrom> {
  String table;

  TableFrom(String table) {
    this.table = table;
  }

  @override
  String build() {
    String ret = (!QueryBuilderUtils.isNullOrWhiteSpace(table) ? table : "");

    if (!QueryBuilderUtils.isNullOrWhiteSpace(alias)) ret = ret + " AS " + alias;

    return ret;
  }

  @override
  List buildParameters() {
    return QueryBuilderUtils.EMPTY_LIST;
  }
}
