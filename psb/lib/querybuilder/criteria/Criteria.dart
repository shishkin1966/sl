import 'package:psb/querybuilder/criteria/BasicCriteria.dart';
import 'package:psb/querybuilder/criteria/BetweenCriteria.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

abstract class Criteria {
  // Null
  static Criteria isNull(dynamic object) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.IS_NULL, null);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.IS_NULL, null);
    }
  }

  static Criteria notIsNull(dynamic object) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.IS_NOT_NULL, null);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.IS_NOT_NULL, null);
    }
  }

  static Criteria equals(dynamic object, Object value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.EQUALS, value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.EQUALS, value);
    }
  }

  static Criteria notEquals(dynamic object, Object value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.NOT_EQUALS, value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.NOT_EQUALS, value);
    }
  }

  static Criteria greaterThan(dynamic object, Object value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.GREATER, value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.GREATER, value);
    }
  }

  static Criteria lesserThan(dynamic object, Object value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.LESSER, value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.LESSER, value);
    }
  }

  static Criteria greaterThanOrEqual(dynamic object, Object value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.GREATER_OR_EQUALS, value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.GREATER_OR_EQUALS, value);
    }
  }

  static Criteria lesserThanOrEqual(dynamic object, Object value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.LESSER_OR_EQUALS, value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.LESSER_OR_EQUALS, value);
    }
  }

  static Criteria startsWith(dynamic object, String value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.LIKE, value + "%");
    } else {
      return new BasicCriteria(Projection.column(object), Operators.LIKE, value + "%");
    }
  }

  static Criteria notStartsWith(dynamic object, String value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.NOT_LIKE, value + "%");
    } else {
      return new BasicCriteria(Projection.column(object), Operators.NOT_LIKE, value + "%");
    }
  }

  static Criteria endsWith(dynamic object, String value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.LIKE, "%" + value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.LIKE, "%" + value);
    }
  }

  static Criteria notEndsWith(dynamic object, String value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.NOT_LIKE, "%" + value);
    } else {
      return new BasicCriteria(Projection.column(object), Operators.NOT_LIKE, "%" + value);
    }
  }

  static Criteria contains(dynamic object, String value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.LIKE, "%" + value + "%");
    } else {
      return new BasicCriteria(Projection.column(object), Operators.LIKE, "%" + value + "%");
    }
  }

  static Criteria notContains(dynamic object, String value) {
    if (object is Projection) {
      return new BasicCriteria(object, Operators.NOT_LIKE, "%" + value + "%");
    } else {
      return new BasicCriteria(Projection.column(object), Operators.NOT_LIKE, "%" + value + "%");
    }
  }

  static Criteria between(dynamic object, Object valueMin, Object valueMax) {
    if (object is Projection) {
      return new BetweenCriteria(object, valueMin, valueMax);
    } else {
      return new BetweenCriteria(Projection.column(object), valueMin, valueMax);
    }
  }

  String build();

  List buildParameters();
}
