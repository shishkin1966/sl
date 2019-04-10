import 'package:psb/app/data/Ticker.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ResponseListener.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/ui/WidgetState.dart';
import 'package:uuid/uuid.dart';

class RatesScreenPresenter<RatesScreenState extends WidgetState> extends AbsPresenter<RatesScreenState>
    implements ResponseListener {
  static const String NAME = "RatesScreenPresenter";

  RatesScreenPresenter(RatesScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is ApplicationAction) {
      String actionName = action.getName();
      switch (actionName) {
        case Actions.Refresh:
          _getRates();
          break;
      }
    }
  }

  void _getRates() {
    getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
    SLUtil.getRepositorySpecialist().getRates(NAME, id: new Uuid().v4());
  }

  @override
  void onReady() {
    super.onReady();

    _getRates();
  }

  @override
  void response(Result result) {
    getWidget().addAction(new ApplicationAction(Actions.HideHorizontalProgress));
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetRates:
          List<Ticker> list = result.getData();
          list.sort((a, b) {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
          getWidget().addAction(new DataAction(result.getName()).setData(list));
          break;
      }
    } else {
      SLUtil.getUISpecialist().showErrorToast(result.getErrorText());
    }
  }
}
