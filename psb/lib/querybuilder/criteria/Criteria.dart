import 'package:psb/querybuilder/SqliteQueryBuilder.dart';
import 'package:psb/querybuilder/criteria/AndCriteria.dart';
import 'package:psb/querybuilder/criteria/BasicCriteria.dart';
import 'package:psb/querybuilder/criteria/BetweenCriteria.dart';
import 'package:psb/querybuilder/criteria/ExistsCriteria.dart';
import 'package:psb/querybuilder/criteria/InCriteria.dart';
import 'package:psb/querybuilder/criteria/NotExistsCriteria.dart';
import 'package:psb/querybuilder/criteria/NotInCriteria.dart';
import 'package:psb/querybuilder/criteria/OrCriteria.dart';
import 'package:psb/querybuilder/criteria/ValueBetweenCriteria.dart';
import 'package:psb/querybuilder/projection/Projection.dart';

abstract class Criteria {
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

  static Criteria valueBetween(dynamic value, dynamic columnMin, dynamic columnMax) {
    if (columnMin is Projection && columnMax is Projection) {
      return new ValueBetweenCriteria(value, columnMin, columnMax);
    } else {
      return new ValueBetweenCriteria(value, Projection.column(columnMin), Projection.column(columnMax));
    }
  }

  static Criteria exists(SqliteQueryBuilder subQuery) {
    return new ExistsCriteria(subQuery);
  }

  static Criteria notExists(SqliteQueryBuilder subQuery) {
    return new NotExistsCriteria(subQuery);
  }

  static Criteria inValues(dynamic object, List values) {
    if (object is Projection) {
      return new InCriteria(object, values);
    } else {
      return new InCriteria(Projection.column(object), values);
    }
  }

  static Criteria notInValues(dynamic object, List values) {
    if (object is Projection) {
      return new NotInCriteria(object, values);
    } else {
      return new NotInCriteria(Projection.column(object), values);
    }
  }

  AndCriteria and(Criteria criteria) {
    return new AndCriteria(this, criteria);
  }

  OrCriteria or(Criteria criteria) {
    return new OrCriteria(this, criteria);
  }

  String build();

  List buildParameters();
}
