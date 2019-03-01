import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/specialist/messager/MessengerSubscriber.dart';
import 'package:psb/sl/state/StateListener.dart';
import 'package:psb/ui/WidgetState.dart';

///
/// Презентер
///
abstract class Presenter<M extends WidgetState> implements StateListener, MessengerSubscriber {
  ///
  /// Получить виджет презентера
  ///
  /// @return виджет презентера
  ///
  WidgetState getWidget();

  ///
  /// Событие, наступающее при поступлении действия
  ///
  /// @param action действие
  ///
  void onAction(Action action);

  ///
  /// Добавить действие на презентер
  ///
  /// @param action действие
  ///
  void addAction(Action action);
}
