import 'package:psb/sl/AbsSpecialist.dart';

abstract class RepositorySpecialist extends AbsSpecialist {
  void getAccounts(String subscriber);

  void getOperations(String subscriber);

  Future getRates(String subscriber, {String id});

  Future getContacts(String subscriber, String filter, {String id});
}
