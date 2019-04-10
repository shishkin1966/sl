import 'package:psb/sl/Specialist.dart';

abstract class RepositorySpecialist extends Specialist {
  void getAccounts(String subscriber);

  void getOperations(String subscriber);

  Future getRates(String subscriber, {String id});

  Future getContacts(String subscriber, String filter, {String id});
}
