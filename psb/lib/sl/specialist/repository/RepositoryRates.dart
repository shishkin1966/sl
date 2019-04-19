import 'dart:async';

import 'package:dio/dio.dart';
import 'package:isolate/isolate.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ResultMessage.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:sqflite/sqlite_api.dart';

class RepositoryRates {
  static const String Subscriber = "Subscriber";
  static const String Data = "Data";
  static const String Id = "Id";

  static Future cleanRates(String subscriber) async {
    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getWriteDb();
      await db.transaction(
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

  static Future getRatesDb(String subscriber) async {
    final runner = await IsolateRunner.spawn();
    return runner.run(_getRatesDb, {Subscriber: subscriber}).whenComplete(() => runner.close());
  }

  static Future _getRatesDb(Map<String, dynamic> map) async {
    String subscriber = map[Subscriber];
    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getReadDb();
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
      cnt = await db.transaction(
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

  static Future saveRates(String subscriber, List<Ticker> list) async {
    final runner = await IsolateRunner.spawn();
    return runner.run(_saveRates, {Subscriber: subscriber, Data: list}).whenComplete(() => runner.close());
  }

  static Future _saveRates(Map<String, dynamic> map) async {
    String subscriber = map[Subscriber];
    List<Ticker> list = map[Data];

    if (list == null) return;

    Database db;
    try {
      db = await SLUtil.repositorySpecialist.getWriteDb();
      await db.transaction(
        (txn) async {
          await txn.delete(Ticker.Table);
          for (Ticker ticker in list) {
            txn.insert(Ticker.Table, ticker.toMap());
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

  static Future getRates(String subscriber, {String id}) async {
    SLUtil.uiSpecialist.showToast("getRates");
    final runner = await IsolateRunner.spawn();
    SLUtil.uiSpecialist.showToast("getRates 1");
    return runner.run(_getRates, {Subscriber: subscriber, Id: id}).whenComplete(() => runner.close());
  }

  static FutureOr _getRates(Map<String, dynamic> map) async {
    SLUtil.uiSpecialist.showToast("getRates 2");
    String subscriber = map[Subscriber];
    String id = map[Id];

    if (!SLUtil.connectivitySpecialist.isConnected()) {
      SLUtil.uiSpecialist.showToast("Сеть отключена");
      Result<List<Ticker>> result = new Result<List<Ticker>>(new List()).setName(Repository.GetRates);
      ResultMessage message = new ResultMessage.result(subscriber, result);
      SLUtil.addNotMandatoryMessage(message);
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
        ResultMessage message = new ResultMessage.result(subscriber, result);
        SLUtil.addNotMandatoryMessage(message);
      }
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.GetRates, e, id);
    }
  }
}
