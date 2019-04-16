import 'package:psb/querybuilder/from/From.dart';

abstract class AliasableFrom<T> extends From {
  String _alias;

  T as(String alias) {
    _alias = alias;
    return this as T;
  }

  String get alias {
    return _alias;
  }
}
