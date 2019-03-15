///
/// Действие
///
class Action {
  bool _needRefresh = true;

  Action setNeedRefresh(bool needRefresh) {
    _needRefresh = needRefresh;
    return this;
  }

  bool isNeedRefresh() {
    return _needRefresh;
  }
}
