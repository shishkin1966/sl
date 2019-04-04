import 'dart:async';

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
  static const String GetAddress = "GetAddress";

  var _geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

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

    Geolocator().checkGeolocationPermissionStatus().then((status) {
      if (status == GeolocationStatus.granted) {
        _getLocation();
      } else {
        PermissionHandler()
            .checkPermissionStatus(PermissionGroup.locationAlways)
            .then((permission) {
          if (permission != PermissionStatus.granted) {
            PermissionHandler().requestPermissions(
                [PermissionGroup.locationAlways]).then((map) {
              if (map[PermissionGroup.locationAlways] ==
                  PermissionStatus.granted) {
                _getLocation();
              }
            });
          }
        });
      }
    });
  }

  void _getLocation() async {
    var geolocator = Geolocator();

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      getWidget().addAction(new DataAction(LocationChanged).setData(position));
      _getAddress(position);
    });

    geolocator.getPositionStream(locationOptions).listen((position) {
      getWidget().addAction(new DataAction(LocationChanged).setData(position));
      _getAddress(position);
    });
  }

  void _getAddress(Position position) async {
    Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "ru")
        .then((placemark) {
      StringBuffer sb = new StringBuffer();
      if (placemark.isNotEmpty) {
        sb.write(placemark[0].subAdministrativeArea + ", ");
        sb.write(placemark[0].thoroughfare + " ");
        sb.write(placemark[0].name);
        getWidget()
            .addAction(new DataAction(GetAddress).setData(sb.toString()));
      }
    });
  }
}
