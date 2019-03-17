import 'package:psb/app/data/Account.dart';

class ApplicationData {
  static final ApplicationData _instance = new ApplicationData._internal();

  static ApplicationData get instance => _instance;

  List<Account> accounts = new List();

  ApplicationData._internal() {}
}
