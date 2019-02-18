import 'package:sl/sl/data/Result.dart';

///
/// Проверяемый
///
abstract class Validated {
  ///
  /// Получить расширенную информацию о готовности объекта
  ///
  /// @return расширенная информация о готовности объекта
  ///
  Result<bool> validateExt();

  ///
  /// Проверить готовность объекта
  ///
  /// @return true - объект готов
  ///
  bool validate();
}
