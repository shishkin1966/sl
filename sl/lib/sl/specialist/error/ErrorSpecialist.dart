import 'package:sl/sl/Specialist.dart';

abstract class ErrorSpecialist extends Specialist {
  void onError(String source, Exception e);

  void onErrorDisplay(final String source, Exception e, final String message);

  void onErrorMessage(String source, String message);
}
