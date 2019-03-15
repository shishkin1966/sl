import 'package:psb/app/repository/ApplicationData.dart';
import 'package:psb/app/repository/Repository.dart';
import 'package:psb/app/router/Router.dart';
import 'package:psb/app/screen/drawer/ExtDrawerPresenter.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ActionMessage.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/sl/request/ResponseListener.dart';
import 'package:psb/ui/WidgetState.dart';

class HomeScreenPresenter<HomeScreenState extends WidgetState> extends AbsPresenter<HomeScreenState>
    implements ResponseListener {
  static const String NAME = "HomeScreenPresenenter";
  static const String CreateAccount = "CreateAccount";
  static const String SortBy = "SortBy";
  static const String SelectBy = "SelectBy";
  static const String WidgetHorizontalProgress = 'HorizontalProgress';
  static const String WidgetRefreshOperations = 'WidgetRefreshOperations';
  static const String WidgetBottomMenu = 'WidgetBottomMenu';

  HomeScreenPresenter(HomeScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Router.ShowAccountsScreen:
          Router.showAccountsScreen(getWidget().context);
          break;

        case Router.ShowSettingsScreen:
          Router.showSettingsScreen(getWidget().context);
          break;

        case Router.ShowRatesScreen:
          Router.showRatesScreen(getWidget().context);
          break;

        case Router.ShowAddressScreen:
          Router.showAddressScreen(getWidget().context);
          break;

        case Router.ShowContactsScreen:
          Router.showContactsScreen(getWidget().context);
          break;

        case CreateAccount:
          _createAccount();
          break;

        case SortBy:
          _sortBy();
          break;

        case SelectBy:
          _selectBy();
          break;

        case Actions.Refresh:
          getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
          // Получим операции
          Repository.getOperations(NAME);
          break;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
    // Получим счета
    Repository.getAccounts(NAME);
    // Получим операции
    Repository.getOperations(NAME);
  }

  @override
  void response(Result result) {
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetAccounts:
          ApplicationData.instance.accounts = result.getData();
          ActionMessage message =
              new ActionMessage.action(ExtDrawerPresenter.NAME, new ApplicationAction(Actions.Refresh));
          SLUtil.addMessage(message);
          break;

        case Repository.GetOperations:
          getWidget().addAction(new ApplicationAction(Actions.HideHorizontalProgress));
          getWidget().addAction(new DataAction(Repository.GetOperations).setData(result.getData()));
          break;
      }
    } else {
      getWidget().addAction(new ApplicationAction(Actions.HideHorizontalProgress));
      SLUtil.getUISpecialist().showErrorToast(result.getErrorText());
    }
  }

  void _createAccount() {}

  void _sortBy() {}

  void _selectBy() {}
}
