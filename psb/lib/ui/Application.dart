import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/app/screen/home/HomeScreenPresenter.dart';
import 'package:psb/sl/SL.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/ActionMessage.dart';
import 'package:psb/sl/message/Message.dart';
import 'package:psb/sl/specialist/messager/MessengerSubscriber.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/router/Router.dart';
import 'package:psb/sl/state/States.dart';

class Application extends StatelessWidget implements MessengerSubscriber {
  static const String NAME = "Application";

  final SL _sl = SL.instance;

  @override
  Widget build(BuildContext context) {}

  @override
  String getName() {
    return NAME;
  }

  @override
  String getPassport() {
    return NAME;
  }

  @override
  List<String> getSpecialistSubscription() {
    return [MessengerUnionImpl.NAME];
  }

  @override
  String getState() {
    return States.StateReady;
  }

  @override
  void read(Message message) {
    if (message is ActionMessage) {
      Action action = message.getAction();
      if (action is ApplicationAction) {
        String actionName = action.getName();
        switch (actionName) {
          case Actions.ExitApplication:
            SL.instance.clear();

            HomeScreenPresenter presenter =
                SLUtil.presenterUnion.getPresenter(HomeScreenPresenter.NAME);
            if (presenter != null) {
              BuildContext context = presenter.getWidget().context;
              Navigator.popUntil(context, (route) {
                String name = route.settings.name;
                switch (name) {
                  case "/":
                  case Router.ShowHomeScreen:
                    return true;
                }
                return false;
              });
            }
            SystemNavigator.pop(); // Exit only Android
            //exit(0);
            break;
        }
      }
    }
  }

  @override
  void setState(String state) {}

  @override
  bool validate() {
    return validateExt().getData();
  }

  @override
  Result<bool> validateExt() {
    return new Result(true);
  }
}
