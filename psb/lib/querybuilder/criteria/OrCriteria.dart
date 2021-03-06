import 'package:psb/querybuilder/criteria/Criteria.dart';

class OrCriteria extends Criteria {
  Criteria _left;
  Criteria _right;

  OrCriteria(Criteria left, Criteria right) {
    _left = left;
    _right = right;
  }

  @override
  String build() {
    String ret = " OR ";

    if (_left != null) ret = _left.build() + ret;

    if (_right != null) ret = ret + _right.build();

    return "(" + ret.trim() + ")";
  }

  @override
  List buildParameters() {
    List ret = new List();

    if (_left != null) ret.addAll(_left.buildParameters());

    if (_right != null) ret.addAll(_right.buildParameters());

    return ret;
  }
}
