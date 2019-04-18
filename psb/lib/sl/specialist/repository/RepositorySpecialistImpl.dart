import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
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
import 'package:sync/sync.dart';

class RepositorySpecialistImpl extends AbsSpecialist implements RepositorySpecialist {
  static const String NAME = "RepositorySpecialistImpl";

  Mutex _mutex = new Mutex();
  Map<String, String> _map = new Map();
  String _path;

  @override
  Future<Database> getWriteDb() async {
    if (StringUtils.isNullOrEmpty(_path)) {
      String databasesPath = await getDatabasesPath();
      _path = databasesPath + "/psb.db";
    }
    Database db = await openDatabase(
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
    return db;
  }

  @override
  Future<Database> getReadDb() async {
    if (StringUtils.isNullOrEmpty(_path)) {
      String databasesPath = await getDatabasesPath();
      _path = databasesPath + "/psb.db";
    }
    Database db = await openDatabase(
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
  Future getRates(String subscriber, {String id}) async {
    if (!SLUtil.connectivitySpecialist.isConnected()) return;

    await addLock(Repository.GetRates, id);

    try {
      List<Ticker> list = new List();
      Response response = await Dio().get("https://api.coinmarketcap.com/v1/ticker/");
      List<dynamic> data = response.data;
      for (Map<String, dynamic> map in data) {
        Ticker ticker = Ticker.fromMap(map);
        list.add(ticker);
      }
      bool found = await checkLock(Repository.GetRates, id);
      if (found) {
        Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRates);
        ResultMessage message = new ResultMessage.result(subscriber, result);
        SLUtil.addNotMandatoryMessage(message);
      }
    } catch (e) {
      _onError(subscriber, Repository.GetRates, e, id);
    }
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
      _onError(subscriber, Repository.GetContacts, e, id);
    }
  }

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
  Future saveRates(String subscriber, List<Ticker> list) async {
    if (list == null) return;

    Database db;
    try {
      db = await getWriteDb();
      await db.transaction(
        (txn) async {
          await txn.delete(Ticker.Table);
          for (Ticker ticker in list) {
            txn.insert(Ticker.Table, ticker.toMap());
          }
        },
      );
    } catch (e) {
      _onError(subscriber, Repository.SaveRates, e);
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  Future _onError(String subscriber, String idRequest, dynamic e, [String id]) async {
    SLUtil.onError(NAME, e);
    await removeLock(idRequest, id);
    Result result = new Result(null).addError(subscriber, e.toString()).setName(idRequest);
    ResultMessage message = new ResultMessage.result(subscriber, result);
    SLUtil.addNotMandatoryMessage(message);
  }

  @override
  Future<int> countRates(String subscriber) async {
    int cnt = 0;
    Database db;
    try {
      db = await getReadDb();
      cnt = await db.transaction(
        (txn) async {
          List<Map<String, dynamic>> records = await txn.query(Ticker.Table, columns: ["count(*) as cnt"]);
          int count = records[0]["cnt"];
          return count;
        },
      );
      return cnt;
    } catch (e) {
      _onError(subscriber, Repository.CountRates, e);
      return cnt;
    } finally {
      if (db != null) {
        db.close();
      }
    }
  }

  @override
  Future cleanRates(String subscriber) async {
    Database db;
    try {
      db = await getWriteDb();
      await db.transaction(
        (txn) async {
          await txn.delete(Ticker.Table);
        },
      );
    } catch (e) {
      _onError(subscriber, Repository.CleanRates, e);
    } finally {
      if (db != null) {
        db.close();
      }
    }
  }

  @override
  Future getRatesDb(String subscriber) async {
    Database db;
    try {
      db = await getReadDb();
      await db.transaction(
        (txn) async {
          List<Map<String, dynamic>> records = await txn.query(Ticker.Table);
          List<Ticker> list = new List();
          for (Map<String, dynamic> map in records) {
            list.add(Ticker.fromMap(map));
          }
          Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRatesDb);
          ResultMessage message = new ResultMessage.result(subscriber, result);
          SLUtil.addNotMandatoryMessage(message);
        },
      );
    } catch (e) {
      _onError(subscriber, Repository.GetRatesDb, e);
    } finally {
      if (db != null) {
        db.close();
      }
    }
  }
}
