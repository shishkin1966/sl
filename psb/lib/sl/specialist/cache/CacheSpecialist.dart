import 'package:psb/sl/AbsSpecialist.dart';

abstract class CacheSpecialist extends AbsSpecialist {
  void put(String key, dynamic data, {Duration duration});

  Future get(String key);

  void check();
}
