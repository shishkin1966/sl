import 'package:psb/app/data/Ticker.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:sqflite/sqflite.dart';

abstract class RepositorySpecialist extends AbsSpecialist {
  Future addLock(String key, String id);

  Future removeLock(String key, String id);

  Future<bool> checkLock(String key, String id);

  void getAccounts(String subscriber);

  void getOperations(String subscriber);

  Future getRates(String subscriber, {String id});

  Future getRatesDb(String subscriber);

  Future getContacts(String subscriber, String filter, {String id});

  Future<Database> getWriteDb();

  Future<Database> getReadDb();

  Future saveRates(String subscriber, List<Ticker> list);

  Future<int> countRates(String subscriber);

  Future cleanRates(String subscriber);

  Future onError(String subscriber, String idRequest, dynamic e, [String id]);

  void onResult(String subscriber, Result result);
}
