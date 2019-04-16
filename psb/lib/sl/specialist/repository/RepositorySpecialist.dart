import 'package:flutter/material.dart';
import 'package:psb/app/data/Ticker.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:sqflite/sqflite.dart';

abstract class RepositorySpecialist extends AbsSpecialist {
  void getAccounts(String subscriber);

  void getOperations(String subscriber);

  Future getRates(String subscriber, {String id});

  Future getRatesDb(String subscriber);

  Future getContacts(String subscriber, String filter, {String id});

  Future connectDb(BuildContext context);

  Database getDb();

  Future saveRates(String subscriber, List<Ticker> list);

  Future<int> countRates(String subscriber);

  Future cleanRates(String subscriber);
}
