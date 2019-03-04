import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb/app/repository/Repository.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/Actions.dart';
import 'package:psb/sl/action/ApplicationAction.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/sl/request/ResponseListener.dart';
import 'package:psb/ui/WidgetState.dart';

class ContactsScreenPresenter<ContactsScreenState extends WidgetState> extends AbsPresenter<ContactsScreenState>
    implements ResponseListener {
  static const String NAME = "ContactsScreenPresenter";

  String _filter;

  ContactsScreenPresenter(ContactsScreenState lifecycleState) : super(lifecycleState);

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
          _getContacts();
          break;
      }
    }
  }

  Future _getContacts() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.granted) {
      getWidget().addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
      Repository.getContacts(NAME, _filter);
    } else {
      bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
    }
  }

  @override
  void onReady() {
    super.onReady();

    _getContacts();
  }

  @override
  void response(Result result) {
    getWidget().addAction(new ApplicationAction(Actions.HideHorizontalProgress));
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetContacts:
          List<Contact> list = result.getData();
          list.sort((a, b) {
            return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
          });
          getWidget().addAction(new DataAction(result.getName()).setData(list));
          break;
      }
    } else {
      SLUtil.getUISpecialist().showErrorToast(result.getErrorText());
    }
  }
}
