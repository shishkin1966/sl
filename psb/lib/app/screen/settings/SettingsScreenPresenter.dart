import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class SettingsScreenPresenter<SettingsScreenState extends WidgetState> extends AbsPresenter<SettingsScreenState> {
  static const String NAME = "SettingsScreenPresenter";

  SettingsScreenPresenter(SettingsScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {}
}
