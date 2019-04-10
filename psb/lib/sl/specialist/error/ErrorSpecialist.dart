import 'package:psb/sl/AbsSpecialist.dart';

abstract class ErrorSpecialist extends AbsSpecialist {
  void onError(String source, Exception e);

  void onErrorDisplay(final String source, Exception e, final String message);

  void onErrorMessage(String source, String message);
}
