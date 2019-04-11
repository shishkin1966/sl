import 'dart:async';

import 'package:psb/sl/specialist/cache/CacheRecord.dart';
import 'package:synchronized/synchronized.dart' as Synchronized;
import 'package:system_info/system_info.dart';

class Cache {
  static const int MinFreeMemory = 4 * 1024 * 1024;

  Map<String, CacheRecord> _map = new Map();
  Synchronized.Lock _lock = new Synchronized.Lock();

  Cache() {
    Timer.periodic(const Duration(minutes: 4), (timer) {
      check();
    });
  }

  Future get(String key) async {
    if (_map.containsKey(key)) {
      return await _lock.synchronized(() async {
        CacheRecord record = _map[key];
        if (record.isValid()) {
          return record.data;
        } else {
          _map.remove(key);
        }
      });
    }
    return null;
  }

  Future put(String key, dynamic data, Duration duration) async {
    if (SysInfo.getFreePhysicalMemory() < MinFreeMemory) {
      return;
    }
    await _lock.synchronized(() async {
      if (_map.containsKey(key)) {
        _map.remove(key);
      }
      _map[key] = new CacheRecord(data, duration: duration);
    });
  }

  Future check() async {
    await _lock.synchronized(() async {
      for (String key in _map.keys) {
        if (!_map[key].isValid()) {
          _map.remove(key);
        }
      }
    });
  }

  Future clear(String key) async {
    await _lock.synchronized(() async {
      if (_map.containsKey(key)) {
        _map.remove(key);
      }
    });
  }

  Future clearAll() async {
    await _lock.synchronized(() async {
      _map.clear();
    });
  }
}
