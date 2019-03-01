import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AccountsScreenPresenter<AccountsScreenState extends WidgetState> extends AbsPresenter<AccountsScreenState> {
  static const String NAME = "AccountsScreenPresenter";

  AccountsScreenPresenter(AccountsScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {}
}
