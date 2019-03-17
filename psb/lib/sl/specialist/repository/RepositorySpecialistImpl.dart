import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:psb/app/data/Account.dart';
import 'package:psb/app/data/Currency.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ResultMessage.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialist.dart';

class RepositorySpecialistImpl extends AbsSpecialist implements RepositorySpecialist {
  static const String NAME = "RepositorySpecialistImpl";

  @override
  void getAccounts(String subscriber) {
    Future.delayed(const Duration(seconds: 2), () {
      List<Account> list = new List();
      list.add(new Account(new Currency("RUB"), 220000));
      list.add(new Account(new Currency("USD"), 11500));
      ResultMessage message =
          new ResultMessage.result(subscriber, new Result<List<Account>>(list).setName(Repository.GetAccounts));
      SLUtil.addMessage(message);
    });
  }

  @override
  void getOperations(String subscriber) {
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
          new ResultMessage.result(subscriber, new Result<List<Operation>>(list).setName(Repository.GetOperations));
      SLUtil.addNotMandatoryMessage(message);
    });
  }

  @override
  void getRates(String subscriber) async {
    try {
      List<Ticker> list = new List();
      Response response = await Dio().get("https://api.coinmarketcap.com/v1/ticker/");
      List<dynamic> data = response.data;
      for (Map<String, dynamic> rate in data) {
        Ticker ticker = new Ticker();
        ticker.name = rate["name"];
        list.add(ticker);
      }
      Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.GetRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  @override
  void getContacts(String subscriber, String filter) async {
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
      Result<List<Contact>> result = new Result<List<Contact>>(list).setName(Repository.GetContacts);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.GetContacts);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  @override
  int compareTo(other) {
    return (other is RepositorySpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }
}
