class CacheRecord {
  dynamic data;
  int duration = Duration(minutes: 10).inMilliseconds;
  int _fetchTime = DateTime.now().millisecondsSinceEpoch;

  CacheRecord(dynamic data, {Duration duration = const Duration(minutes: 10)}) {
    this.data = data;
    this.duration = duration.inMilliseconds;
  }

  bool isValid() {
    return DateTime.now().millisecondsSinceEpoch < _fetchTime + duration;
  }
}
