import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:psb/app/data/Account.dart';
import 'package:psb/app/data/Currency.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ResultMessage.dart';

class Repository {
  static const String GetAccounts = "GetAccounts";
  static const String GetOperations = "GetOperations";
  static const String GetRates = "GetRates";
  static const String GetContacts = "GetContacts";

  static void getAccounts(String subscriber) {
    Future.delayed(const Duration(seconds: 2), () {
      List<Account> list = new List();
      list.add(new Account(new Currency("RUB"), 220000));
      list.add(new Account(new Currency("USD"), 11500));
      ResultMessage message =
          new ResultMessage.result(subscriber, new Result<List<Account>>(list).setName(GetAccounts));
      SLUtil.addMessage(message);
    });
  }

  static void getOperations(String subscriber) {
    Future.delayed(const Duration(seconds: 2), () {
      List<Operation> list = new List();
      Operation operation = new Operation();
      operation.name = "Анюте";
      operation.when = new DateTime(2019, 2, 15, 11, 20);
      operation.amount = 220;
      operation.status = "Обработано";
      list.add(operation);

      operation = new Operation();
      operation.name = "Олег";
      operation.when = new DateTime(2019, 2, 8, 9, 32);
      operation.amount = 100;
      operation.status = "Обработано";
      list.add(operation);

      operation = new Operation();
      operation.name = "Между своими счетами ПСБ";
      operation.when = new DateTime(2019, 2, 2, 18, 1);
      operation.amount = 2000;
      operation.status = "Обработано";
      list.add(operation);

      ResultMessage message =
          new ResultMessage.result(subscriber, new Result<List<Operation>>(list).setName(GetOperations));
      SLUtil.addNotMandatoryMessage(message);
    });
  }

  static void getRates(String subscriber) async {
    try {
      List<Ticker> list = new List();
      Response response = await Dio().get("https://api.coinmarketcap.com/v1/ticker/");
      List<dynamic> data = response.data;
      for (Map<String, dynamic> rate in data) {
        Ticker ticker = new Ticker();
        ticker.name = rate["name"];
        list.add(ticker);
      }
      Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(GetRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(GetRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  static void getContacts(String subscriber, String filter) async {
    try {
      List<Contact> list = new List();
      Iterable<Contact> data;
      if (StringUtils.isNullOrEmpty(filter)) {
        data = await ContactsService.getContacts();
      } else {
        data = await ContactsService.getContacts(
          query: filter,
          withThumbnails: true,
        );
      }
      list.addAll(data);
      Result<List<Contact>> result = new Result<List<Contact>>(list).setName(GetContacts);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(GetContacts);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }
}
