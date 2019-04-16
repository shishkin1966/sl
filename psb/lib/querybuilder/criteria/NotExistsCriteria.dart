import 'package:psb/querybuilder/SqliteQueryBuilder.dart';
import 'package:psb/querybuilder/criteria/ExistsCriteria.dart';

class NotExistsCriteria extends ExistsCriteria {
  NotExistsCriteria(SqliteQueryBuilder subQuery) : super(subQuery);

  @override
  String build() {
    return "NOT " + super.build();
  }
}
