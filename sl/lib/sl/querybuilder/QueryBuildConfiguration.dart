import 'package:intl/intl.dart';

class QueryBuildConfiguration {
  DateFormat _dateFormat = new DateFormat("yyyy-MM-dd");
  DateFormat _dateTimeFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");

  static final QueryBuildConfiguration _configuration = new QueryBuildConfiguration._internal();

  QueryBuildConfiguration._internal() {}

  static QueryBuildConfiguration get instance => _configuration;

  DateFormat getDateFormat() {
    return _dateFormat;
  }

  DateFormat getDateTimeFormat() {
    return _dateTimeFormat;
  }

  void setDateFormat(String format) {
    _dateFormat = new DateFormat(format);
  }

  void setDateTimeFormat(String format) {
    _dateTimeFormat = new DateFormat(format);
  }
}
