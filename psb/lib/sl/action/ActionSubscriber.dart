import 'package:psb/sl/action/Action.dart';

abstract class ActionSubscriber {
  ///
  /// Добавить действие на обработку
  ///
  /// @param action действие
  ///
  void addAction(Action action);
}
