import 'package:psb/app/ApplicationData.dart';
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
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/sl/specialist/router/Router.dart';
import 'package:psb/ui/WidgetState.dart';

class HomeScreenPresenter<HomeScreenState extends WidgetState> extends AbsPresenter<HomeScreenState>
    implements ResponseListener {
  static const String NAME = "HomeScreenPresenenter";
  static const String CreateAccount = "CreateAccount";
  static const String SortBy = "SortBy";
  static const String SelectBy = "SelectBy";

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
          SLUtil.getRouterSpecialist().showAccountsScreen(getWidget().getScaffoldState().context);
          break;

        case Router.ShowSettingsScreen:
          SLUtil.getRouterSpecialist().showSettingsScreen(getWidget().getScaffoldState().context);
          break;

        case Router.ShowRatesScreen:
          SLUtil.getRouterSpecialist().showRatesScreen(getWidget().getScaffoldState().context);
          break;

        case Router.ShowAddressScreen:
          SLUtil.getRouterSpecialist().showAddressScreen(getWidget().getScaffoldState().context);
          break;

        case Router.ShowContactsScreen:
          SLUtil.getRouterSpecialist().showContactsScreen(getWidget().getScaffoldState().context);
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
          SLUtil.getRepositorySpecialist().getOperations(NAME);
          break;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
    // Получим счета
    SLUtil.getRepositorySpecialist().getAccounts(NAME);
    // Получим операции
    SLUtil.getRepositorySpecialist().getOperations(NAME);
  }

  @override
  void response(Result result) {
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetAccounts:
          ApplicationData.instance.accounts = result.getData();
          SLUtil.addMessage(new ActionMessage.action(ExtDrawerPresenter.NAME, new ApplicationAction(Actions.Refresh)));
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
