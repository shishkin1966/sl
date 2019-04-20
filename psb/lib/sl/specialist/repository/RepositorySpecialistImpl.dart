import 'dart:async';
import 'dart:isolate';

import 'package:contacts_service/contacts_service.dart';
import 'package:isolate/isolate.dart';
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
import 'package:psb/sl/specialist/repository/RepositoryRates.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sync/sync.dart';

class RepositorySpecialistImpl extends AbsSpecialist implements RepositorySpecialist {
  static const String NAME = "RepositorySpecialistImpl";

  static const String Id = "Id";
  static const String Data = "Data";
  static const String Subscriber = "Subscriber";

  Mutex _mutex = new Mutex();
  Map<String, String> _map = new Map();
  String _path;
  ReceivePort _port = new ReceivePort();

  @override
  Future<Database> getWriteDb() async {
    if (StringUtils.isNullOrEmpty(_path)) {
      String databasesPath = await getDatabasesPath();
      _path = databasesPath + "/psb.db";
    }

    Database db;
    try {
      db = await openDatabase(
        _path,
        version: 1,
        onCreate: (Database db, int version) async {
          String sql = await AppUtils.getSQL("createDb.sql");
          await db.execute(sql);
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {},
        singleInstance: false,
        readOnly: false,
      );
    } catch (e) {
      onError(null, null, e);
    }
    return db;
  }

  @override
  Future<Database> getReadDb() async {
    if (StringUtils.isNullOrEmpty(_path)) {
      String databasesPath = await getDatabasesPath();
      _path = databasesPath + "/psb.db";
    }

    Database db;
    try {
      db = await openDatabase(
        _path,
        version: 1,
        onCreate: (Database db, int version) async {
          String sql = await AppUtils.getSQL("createDb.sql");
          await db.execute(sql);
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {},
        singleInstance: false,
        readOnly: false,
      );
    } catch (e) {
      onError(null, null, e);
    }
    return db;
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
  Future getContacts(String subscriber, String filter, {String id}) async {
    await addLock(Repository.GetContacts, id);

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
      bool found = await checkLock(Repository.GetContacts, id);
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
      onError(subscriber, Repository.GetContacts, e, id);
    }
  }

  @override
  Future addLock(String key, String id) async {
    if (!StringUtils.isNullOrEmpty(id)) {
      await _mutex.acquire();
      try {
        if (_map.containsKey(key)) {
          _map.remove(key);
        }
        _map[key] = id;
      } finally {
        _mutex.release();
      }
    }
  }

  @override
  Future removeLock(String key, String id) async {
    if (!StringUtils.isNullOrEmpty(id)) {
      await _mutex.acquire();
      try {
        if (_map.containsKey(key) && _map[key] == id) {
          _map.remove(key);
        }
      } finally {
        _mutex.release();
      }
    }
  }

  @override
  Future<bool> checkLock(String key, String id) async {
    await _mutex.acquire();
    try {
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
    } finally {
      _mutex.release();
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

  @override
  void onResult(String subscriber, Result result) {
    ResultMessage message = new ResultMessage.result(subscriber, result);
    SLUtil.addNotMandatoryMessage(message);
  }

  @override
  Future onError(String subscriber, String idRequest, dynamic e, [String id]) async {
    SLUtil.onError(NAME, e);
    if (!StringUtils.isNullOrEmpty(subscriber)) {
      await removeLock(idRequest, id);
      Result result = new Result(null).addError(subscriber, e.toString()).setName(idRequest);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
    }
  }

  @override
  Future<int> countRates(String subscriber) {
    return RepositoryRates.countRates(subscriber);
  }

  @override
  Future cleanRates(String subscriber) {
    return RepositoryRates.cleanRates(subscriber);
  }

  @override
  Future getRatesDb(String subscriber) async {
    var runner = await IsolateRunner.spawn();
    Runner().run(RepositoryRates.getRatesDb, {Subscriber: subscriber}).whenComplete(() {
      runner.close();
    });
  }

  @override
  Future saveRates(String subscriber, List<Ticker> list) async {
    var runner = await IsolateRunner.spawn();
    Runner().run(RepositoryRates.saveRates, {Data: list, Subscriber: subscriber}).whenComplete(() {
      runner.close();
    });
  }

  @override
  Future getRates(String subscriber, {String id}) async {
    var runner = await IsolateRunner.spawn();
    Runner().run(RepositoryRates.getRates, {Subscriber: subscriber, Id: id}).whenComplete(() {
      runner.close();
    });
  }
}
