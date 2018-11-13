import 'package:sl/sl/data/ExtError.dart';

class Result<T> {
  static const NOT_SEND = -1;
  static const LAST = -2;

  T _data;
  ExtError extError;
  int order = NOT_SEND;
  String name;
  int id = 0;

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
    this.extError = extError;
    return this;
  }

  Result addError(final String owner, final String error) {
    if (extError == null) {
      extError = new ExtError();
    }
    extError.owner = owner;
    extError.addError(error);
    return this;
  }

  Result addException(final String owner, final Exception exception) {
    if (extError == null) {
      extError = new ExtError();
    }
    extError.owner = owner;
    extError.addError(exception.toString());
    return this;
  }

  String getErrorText() {
    if (extError != null) {
      return extError.errorText;
    }
    return null;
  }

  bool isEmpty() {
    return (_data == null);
  }

  bool hasError() {
    if (extError != null) {
      return extError.hasError();
    }
    return false;
  }
}
