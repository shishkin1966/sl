import 'package:psb/app/data/Currency.dart';

class Account {
  double amount = 0;
  Currency currency;

  Account(Currency currency, double amount) {
    this.currency = currency;
    this.amount = amount;
  }
}
