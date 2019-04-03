import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenPresenter<AddressScreenState extends WidgetState>
    extends AbsPresenter<AddressScreenState> {
  static const String NAME = "AddressScreenPresenter";
  static const String LocationChanged = "LocationChanged";
  static const String CameraMoved = "CameraMoved";

  AddressScreenPresenter(AddressScreenState lifecycleState)
      : super(lifecycleState);

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

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationAlways)
        .then((permission) {
      if (permission != PermissionStatus.granted) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.locationAlways]).then((map) {
          if (map[PermissionGroup.locationAlways] == PermissionStatus.granted) {
            _getLocation();
          }
        });
      } else {
        _getLocation();
      }
    });
  }

  void _getLocation() async {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      getWidget().addAction(new DataAction(LocationChanged).setData(position));
    });
  }
}
