import 'package:sl/sl/data/ExtError.dart';

class Result<T> {
  static const NOT_SEND = -1;
  static const LAST = -2;

  T data;
  ExtError extError;
  int order = NOT_SEND;
  String name;
  int id = 0;

  Result(T data) {
    this.data = data;
  }

  Result setData(final T data) {
    this.data = data;
    return this;
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
    return (data == null);
  }

  bool hasError() {
    if (extError != null) {
      return extError.hasError();
    }
    return false;
  }
}
