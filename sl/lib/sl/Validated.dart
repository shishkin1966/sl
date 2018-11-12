import 'package:sl/sl/data/Result.dart';

abstract class Validated {
  Result<bool> validateExt();

  bool validate();
}
