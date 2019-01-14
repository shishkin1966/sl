abstract class Criteria {}

class Operators {
  static const String IS_NULL = "IS NULL";
  static const String IS_NOT_NULL = "IS NOT NULL";
  static const String EQUALS = "=";
  static const String NOT_EQUALS = "<>";
  static const String GREATER = ">";
  static const String LESSER = "<";
  static const String GREATER_OR_EQUALS = ">=";
  static const String LESSER_OR_EQUALS = "<=";
  static const String LIKE = "LIKE";
  static const String NOT_LIKE = "NOT LIKE";
}

class BasicCriteria extends Criteria {}
