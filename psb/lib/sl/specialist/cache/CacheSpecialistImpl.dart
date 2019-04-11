import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/cache/Cache.dart';
import 'package:psb/sl/specialist/cache/CacheSpecialist.dart';

class CacheSpecialistImpl extends AbsSpecialist implements CacheSpecialist {
  static const String NAME = "CacheSpecialistImpl";

  Cache _cache;

  @override
  void onRegister() {
    _cache = new Cache();
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  int compareTo(other) {
    return (other is CacheSpecialist) ? 0 : 1;
  }

  @override
  Future get(String key) {
    return _cache.get(key);
  }

  @override
  void put(String key, data, {Duration duration = const Duration(minutes: 10)}) {
    _cache.put(key, data, duration);
  }

  @override
  void check() {
    _cache.check();
  }

  @override
  void clear(String key) {
    _cache.clear(key);
  }
}
