import 'package:sl/sl/Validated.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class Model extends Validated {
  void addStateObserver(final Stateable stateable);

  void addStateObserver2();
}
