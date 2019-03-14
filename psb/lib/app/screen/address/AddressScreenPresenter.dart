import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenPresenter<AddressScreenState extends WidgetState> extends AbsPresenter<AddressScreenState> {
  static const String NAME = "AddressScreenPresenter";
  static const String LocationChanged = "LocationChanged";
  static const String CameraMoved = "CameraMoved";

  Location _location;

  AddressScreenPresenter(AddressScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {
    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case CameraMoved:
          break;
      }
    }
  }

  @override
  Future onReady() async {
    super.onReady();

    try {
      _location = new Location();

      if (_location.hasPermission == false) {
        PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
        if (permission != PermissionStatus.granted) {
          bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.locationAlways);
        }
      } else {
        LocationData data = await _location.getLocation();
        getWidget().addAction(new DataAction(LocationChanged).setData(data));

        //_location.onLocationChanged().listen((location) async {
        //  getWidget().addAction(new DataAction(LocationChanged).setData(location));
        //});
      }
    } catch (e) {
      SLUtil.onError(NAME, e);
    }
  }
}
