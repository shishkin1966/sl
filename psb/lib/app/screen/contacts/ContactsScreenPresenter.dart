import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
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

class ContactsScreenPresenter<ContactsScreenState extends WidgetState>
    extends AbsPresenter<ContactsScreenState> implements ResponseListener {
  static const String NAME = "ContactsScreenPresenter";

  static const String ChangeFilter = "ChangeFilter";

  String _filter;

  ContactsScreenPresenter(ContactsScreenState lifecycleState)
      : super(lifecycleState);

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
          return;
      }
    }

    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case ChangeFilter:
          _filter = action.getData();
          _getContacts();
          return;
      }
    }
  }

  Future _getContacts() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.granted) {
      getWidget()
          .addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
      SLUtil.getRepositorySpecialist().getContacts(NAME, _filter);
    } else {
      Map<PermissionGroup, PermissionStatus> map = await PermissionHandler()
          .requestPermissions([PermissionGroup.contacts]);
      if (map[PermissionGroup.contacts] == PermissionStatus.granted) {
        getWidget()
            .addAction(new ApplicationAction(Actions.ShowHorizontalProgress));
        SLUtil.getRepositorySpecialist().getContacts(NAME, _filter);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    getWidget().addAction(new ApplicationAction(Actions.ShowKeyboard));
    _getContacts();
  }

  @override
  void onDestroy() {
    super.onDestroy();

    SLUtil.getUISpecialist().hideKeyboard(getWidget().context);
  }

  @override
  void response(Result result) {
    getWidget()
        .addAction(new ApplicationAction(Actions.HideHorizontalProgress));
    if (!result.hasError()) {
      switch (result.getName()) {
        case Repository.GetContacts:
          List<Contact> list = result.getData();
          list.sort((a, b) {
            return a.displayName
                .toLowerCase()
                .compareTo(b.displayName.toLowerCase());
          });
          getWidget().addAction(new DataAction(result.getName()).setData(list));
          break;
      }
    } else {
      SLUtil.getUISpecialist().showErrorToast(result.getErrorText());
    }
  }
}
