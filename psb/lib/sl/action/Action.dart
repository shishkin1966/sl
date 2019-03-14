///
/// Действие
///
class Action {
  bool _isNeedRefresh = true;

  Action setNeedRefresh(bool needRefresh) {
    _isNeedRefresh = needRefresh;
    return this;
  }

  bool getNeedRefresh() {
    return _isNeedRefresh;
  }
}
