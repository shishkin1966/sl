import 'package:psb/sl/data/ExtError.dart';

///
/// Результат
///
class Result<T> {
  static const int NOT_SEND = -1;
  static const int LAST = -2;

  T _data;
  ExtError _extError;
  String _name;

  Result(T data) {
    _data = data;
  }

  Result setData(final T data) {
    _data = data;
    return this;
  }

  T getData() {
    return _data;
  }

  Result setError(final ExtError extError) {
    _extError = extError;
    return this;
  }

  Result addError(final String owner, final String error) {
    if (_extError == null) {
      _extError = new ExtError();
    }
    _extError.owner = owner;
    _extError.addError(error);
    return this;
  }

  Result addException(final String owner, final Exception exception) {
    if (_extError == null) {
      _extError = new ExtError();
    }
    _extError.owner = owner;
    _extError.addError(exception.toString());
    return this;
  }

  String getErrorText() {
    if (_extError != null) {
      return _extError.errorText;
    }
    return null;
  }

  bool isEmpty() {
    return (_data == null);
  }

  bool hasError() {
    if (_extError != null) {
      return _extError.hasError();
    }
    return false;
  }

  String getName() {
    return _name;
  }

  Result setName(String name) {
    _name = name;
    return this;
  }
}
