import 'dart:core';

import 'package:psb/querybuilder/criteria/Criteria.dart';
import 'package:psb/querybuilder/from/From.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

class JoinFrom extends From {
  From _left;
  From _right;
  String _joinType;
  Criteria _criteria;

  JoinFrom(From left, From right, String joinType, Criteria criteria) {
    this._left = left;
    this._right = right;
    this._joinType = joinType;
    this._criteria = criteria;
  }

  JoinFrom onOr({Criteria criteria, String leftColumn, String rightColumn}) {
    if (criteria == null) {
      criteria = Criteria.equals(Projection.column(leftColumn), Projection.column(rightColumn));
    }
    _criteria = (_criteria != null ? _criteria.or(criteria) : criteria);
    return this;
  }

  JoinFrom onAnd({Criteria criteria, String leftColumn, String rightColumn}) {
    if (criteria == null) {
      criteria = Criteria.equals(Projection.column(leftColumn), Projection.column(rightColumn));
    }
    _criteria = (_criteria != null ? _criteria.and(criteria) : criteria);
    return this;
  }

  @override
  String build() {
    String leftSide = (_left != null ? _left.build() : "");
    String rightSide = (_right != null ? _right.build() : "");
    String joinCriteria = (_criteria != null ? _criteria.build() : "");

    return "(" + leftSide + " " + _joinType + " " + rightSide + " ON " + joinCriteria + ")";
  }

  @override
  List buildParameters() {
    List ret = new List();

    if (_left != null) ret.addAll(_left.buildParameters());

    if (_right != null) ret.addAll(_right.buildParameters());

    if (_criteria != null) ret.addAll(_criteria.buildParameters());

    return ret;
  }
}
