import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psb/app/data/Account.dart';
import 'package:psb/app/data/Currency.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/common/AppUtils.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ResultMessage.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart' as Synchronized;

class RepositorySpecialistImpl extends AbsSpecialist implements RepositorySpecialist {
  static const String NAME = "RepositorySpecialistImpl";

  Synchronized.Lock _lock = new Synchronized.Lock();
  Map<String, String> _map = new Map();
  Database _database;

  @override
  Database getDb() {
    return _database;
  }

  @override
  Future connectDb(BuildContext context) async {
    String databasesPath = await getDatabasesPath();
    String path = databasesPath + "/psb.db";
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String sql = await AppUtils.getSQL("create.sql");
        await db.execute(sql);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
    );
  }

  @override
  void getAccounts(String subscriber) {
    Future.delayed(const Duration(seconds: 2), () {
      List<Account> list = new List();
      list.add(new Account(new Currency("RUB"), 364500));
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
  Future getRates(String subscriber, {String id}) async {
    if (!SLUtil.connectivitySpecialist.isConnected()) return;

    await _add(Repository.GetRates, id);

    try {
      List<Ticker> list = new List();
      Response response = await Dio().get("https://api.coinmarketcap.com/v1/ticker/");
      List<dynamic> data = response.data;
      for (Map<String, dynamic> rate in data) {
        Ticker ticker = new Ticker.from(rate);
        list.add(ticker);
      }
      bool found = await _check(Repository.GetRates, id);
      if (found) {
        Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRates);
        ResultMessage message = new ResultMessage.result(subscriber, result);
        SLUtil.addNotMandatoryMessage(message);
      }
    } catch (e) {
      await _remove(Repository.GetRates, id);
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.GetRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  @override
  Future getContacts(String subscriber, String filter, {String id}) async {
    await _add(Repository.GetContacts, id);

    try {
      if (StringUtils.isNullOrEmpty(filter)) {
        var cache = await SLUtil.cacheSpecialist.get(Repository.GetContacts);
        if (cache != null) {
          Result<List<Contact>> result =
              new Result<List<Contact>>(cache as List<Contact>).setName(Repository.GetContacts);
          ResultMessage message = new ResultMessage.result(subscriber, result);
          SLUtil.addNotMandatoryMessage(message);
          return;
        }
      }
      List<Contact> list = new List();
      Iterable<Contact> data;
      if (StringUtils.isNullOrEmpty(filter)) {
        data = await ContactsService.getContacts(
          withThumbnails: true,
        );
      } else {
        data = await ContactsService.getContacts(
          query: filter,
          withThumbnails: true,
        );
      }
      bool found = await _check(Repository.GetContacts, id);
      if (found) {
        list.addAll(data);
        Result<List<Contact>> result = new Result<List<Contact>>(list).setName(Repository.GetContacts);
        ResultMessage message = new ResultMessage.result(subscriber, result);
        SLUtil.addNotMandatoryMessage(message);
        if (StringUtils.isNullOrEmpty(filter)) {
          SLUtil.cacheSpecialist.put(Repository.GetContacts, list);
        }
      }
    } catch (e) {
      await _remove(Repository.GetContacts, id);
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.GetContacts);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  Future _add(String key, String id) async {
    if (!StringUtils.isNullOrEmpty(id)) {
      await _lock.synchronized(() async {
        if (_map.containsKey(key)) {
          _map.remove(key);
        }
        _map[key] = id;
      });
    }
  }

  Future _remove(String key, String id) async {
    if (!StringUtils.isNullOrEmpty(id)) {
      await _lock.synchronized(() async {
        if (_map.containsKey(key) && _map[key] == id) {
          _map.remove(key);
        }
      });
    }
  }

  Future<bool> _check(String key, String id) async {
    return await _lock.synchronized(() async {
      if (!StringUtils.isNullOrEmpty(id)) {
        if (_map.containsKey(key) && _map[key] == id) {
          _map.remove(key);
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    });
  }

  @override
  int compareTo(other) {
    return (other is RepositorySpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  Future saveRates(String subscriber, List<Ticker> list) async {
    if (list == null) return;

    try {
      await _database.transaction((txn) async {
        await txn.delete("Ticker");
        String sql = await AppUtils.getSQL("insertTicker.sql");
        for (Ticker ticker in list) {
          await txn.rawInsert(sql, ticker.toList());
        }
      });
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.SaveRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  @override
  Future<int> countRates(String subscriber) async {
    int cnt = 0;
    try {
      cnt = await _database.transaction((txn) async {
        List<Map<String, dynamic>> records = await txn.query("Ticker", columns: ["count(*) as cnt"]);
        int count = records[0]["cnt"];
        return count;
      });
      return cnt;
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.CountRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
      return cnt;
    }
  }

  @override
  Future cleanRates(String subscriber) async {
    try {
      await _database.transaction((txn) async {
        await txn.delete("Ticker");
      });
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.CleanRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  @override
  Future getRatesDb(String subscriber) async {
    try {
      await _database.transaction((txn) async {
        List<Map<String, dynamic>> records = await txn.query("Ticker");
        List<Ticker> list = new List();
        for (Map<String, dynamic> map in records) {
          list.add(Ticker.from(map));
        }
        Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRatesDb);
        ResultMessage message = new ResultMessage.result(subscriber, result);
        SLUtil.addNotMandatoryMessage(message);
      });
    } catch (e) {
      Result result = new Result(null).addError(subscriber, e.toString()).setName(Repository.GetRatesDb);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }
}
