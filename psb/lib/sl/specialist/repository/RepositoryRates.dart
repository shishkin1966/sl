import 'package:dio/dio.dart';
import 'package:psb/Constant.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:sqflite/sqlite_api.dart';

class RepositoryRates {
  static Future cleanRates(String subscriber) async {
    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getWriteDb();
      await db?.transaction(
        (txn) async {
          await txn.delete(Ticker.Table);
        },
      );
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.CleanRates, e);
    } finally {
      if (db != null) {
        db.close();
      }
    }
  }

  static Future getRatesDb(Map<String, Object> map) async {
    String subscriber = map[Constant.Subscriber];

    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getReadDb();
      await db?.transaction(
        (txn) async {
          List<Map<String, dynamic>> records = await txn.query(Ticker.Table);
          List<Ticker> list = new List();
          for (Map<String, dynamic> map in records) {
            list.add(Ticker.fromMap(map));
          }
          Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRatesDb);
          SLUtil.repositorySpecialist.onResult(subscriber, result);
        },
      );
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.GetRatesDb, e);
    } finally {
      if (db != null) {
        db.close();
      }
    }
  }

  static Future<int> countRates(String subscriber) async {
    int cnt = 0;
    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getReadDb();
      cnt = await db?.transaction(
        (txn) async {
          List<Map<String, dynamic>> records = await txn.query(Ticker.Table, columns: ["count(*) as cnt"]);
          int count = records[0]["cnt"];
          return count;
        },
      );
      return cnt;
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.CountRates, e);
      return cnt;
    } finally {
      if (db != null) {
        db.close();
      }
    }
  }

  static Future saveRates(Map<String, Object> map) async {
    List<Ticker> list = map[Constant.Data];
    String subscriber = map[Constant.Subscriber];

    if (list == null) return;
    if (list.isEmpty) return;

    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getWriteDb();
      await db?.transaction(
        (txn) async {
          int cnt = await txn.delete(Ticker.Table);
          for (Ticker ticker in list) {
            await txn.insert(Ticker.Table, ticker.toMap());
          }
        },
      );
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.SaveRates, e);
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  static Future getRates(Map<String, Object> map) async {
    String subscriber = map[Constant.Subscriber];
    String id = map[Constant.Id];

    if (!SLUtil.connectivitySpecialist.isConnected()) {
      Result<List<Ticker>> result = new Result<List<Ticker>>(new List<Ticker>()).setName(Repository.GetRates);
      SLUtil.repositorySpecialist.onResult(subscriber, result);
      return;
    }

    await SLUtil.repositorySpecialist.addLock(Repository.GetRates, id);

    try {
      List<Ticker> list = new List();
      Response response = await Dio().get("https://api.coinmarketcap.com/v1/ticker/");
      List<dynamic> data = response.data;
      for (Map<String, dynamic> map in data) {
        Ticker ticker = Ticker.fromMap(map);
        list.add(ticker);
      }
      bool found = await SLUtil.repositorySpecialist.checkLock(Repository.GetRates, id);
      if (found) {
        Result<List<Ticker>> result = new Result<List<Ticker>>(list).setName(Repository.GetRates);
        SLUtil.repositorySpecialist.onResult(subscriber, result);
      }
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.GetRates, e, id);
    }
  }
}
