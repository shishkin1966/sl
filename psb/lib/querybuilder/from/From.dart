import 'package:psb/querybuilder/SqliteQueryBuilder.dart';
import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/from/JoinFrom.dart';
import 'package:psb/querybuilder/from/SubQueryFrom.dart';
import 'package:psb/querybuilder/from/TableFrom.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

abstract class From {
  static TableFrom table(String table) {
    return new TableFrom(table);
  }

  static SubQueryFrom subQuery(SqliteQueryBuilder subQuery) {
    return new SubQueryFrom(subQuery);
  }

  PartialJoin innerJoin(dynamic object) {
    if (object is SqliteQueryBuilder) {
      return innerJoin(From.subQuery(object));
    } else if (object is From) {
      return new PartialJoin(this, object, "INNER JOIN");
    } else {
      return innerJoin(From.table(object));
    }
  }

  PartialJoin leftJoin(dynamic object) {
    if (object is SqliteQueryBuilder) {
      return leftJoin(From.subQuery(object));
    } else if (object is From) {
      return new PartialJoin(this, object, "LEFT JOIN");
    } else {
      return leftJoin(From.table(object));
    }
  }

  String build();

  List buildParameters();
}

class PartialJoin {
  String _joinType;
  From _left;
  From _right;

  PartialJoin(From left, From right, String joinType) {
    _joinType = joinType;
    _left = left;
    _right = right;
  }

  JoinFrom on({Criteria criteria, String leftColumn, String rightColumn}) {
    if (criteria == null) {
      criteria = Criteria.equals(Projection.column(leftColumn), Projection.column(rightColumn));
    }
    return new JoinFrom(_left, _right, _joinType, criteria);
  }
}
