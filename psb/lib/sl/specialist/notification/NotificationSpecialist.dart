import 'package:psb/sl/AbsSpecialist.dart';

abstract class NotificationSpecialist extends AbsSpecialist {
  Future showGroupMessage(String title, {String idScreen});

  Future showMessage(String title, String message, {String idScreen});

  Future replaceMessage(String title, String message, {String idScreen});

  Future clear();
}
