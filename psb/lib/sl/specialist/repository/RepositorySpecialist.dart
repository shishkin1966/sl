import 'package:psb/sl/Specialist.dart';

abstract class RepositorySpecialist extends Specialist {
  void getAccounts(String subscriber);

  void getOperations(String subscriber);

  void getRates(String subscriber);

  Future getContacts(String subscriber, String filter, {String id});
}
