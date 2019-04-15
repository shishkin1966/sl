import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/from/JoinFrom.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

abstract class From {
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
