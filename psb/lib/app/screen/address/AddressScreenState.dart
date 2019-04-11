import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psb/app/screen/address/AddressScreenPresenter.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/common/AppUtils.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/AppColor.dart';
import 'package:psb/ui/DataWidget.dart';
import 'package:psb/ui/Dimen.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenState extends WidgetState<AddressScreenWidget> with SingleTickerProviderStateMixin {
  static const double RolledBottomMenuHeight = 64;

  double _bottomPosition = RolledBottomMenuHeight;
  GlobalKey _mapKey = new GlobalKey();
  GlobalKey _bottomKey = new GlobalKey();

  @override
  Presenter<WidgetState<StatefulWidget>> createPresenter() {
    return new AddressScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: new Scaffold(
        key: getScaffoldKey(),
        backgroundColor: Colors.transparent,
        body: new Builder(builder: (BuildContext context) {
          return SafeArea(
            top: true,
            child: _getWidget(),
          );
        }),
      ),
    );
  }

  Widget _getWidget() {
    return new LayoutBuilder(builder: (context, constraints) {
      return new Stack(
        fit: StackFit.expand,
        children: [
          new Container(
            color: Color(AppColor.Background),
          ),
          _showMap(context, constraints),
          _showBottomMenu(context, constraints),
        ],
      );
    });
  }

  Widget _showMap(BuildContext context, BoxConstraints constraints) {
    return new Positioned(
      top: 0,
      left: 0,
      height:
          constraints.maxHeight - _bottomPosition <= 0 ? Dimen.ShadowHeight : constraints.maxHeight - _bottomPosition,
      width: constraints.maxWidth,
      child: new GoogleMapWidget(key: _mapKey),
    );
  }

  Widget _showBottomMenu(BuildContext context, BoxConstraints constraints) {
    return new Positioned(
      top: constraints.maxHeight - _bottomPosition - Dimen.ShadowHeight,
      height: _bottomPosition + Dimen.ShadowHeight,
      left: 0,
      width: constraints.maxWidth,
      child: new Container(
        height: _bottomPosition,
        width: double.infinity,
        child: new NotificationListener(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              if (notification.direction == ScrollDirection.forward) {
                _bottomPosition = RolledBottomMenuHeight;
                setState(() {});
              }
            } else if (notification is OverscrollNotification) {
              if (notification.dragDetails != null) {
                _bottomPosition -= notification.dragDetails.delta.dy * 2;
                if (_bottomPosition < RolledBottomMenuHeight) {
                  _bottomPosition = RolledBottomMenuHeight;
                }
                if (_bottomPosition >= constraints.maxHeight - Dimen.ShadowHeight) {
                  _bottomPosition = constraints.maxHeight - Dimen.ShadowHeight;
                }
                setState(() {});
              }
            }
          },
          child: new ListView(
            children: <Widget>[
              new Container(
                height: Dimen.ShadowHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, Color(AppColor.Shadow)],
                  ),
                ),
              ),
              new Container(
                height: _bottomPosition - 4,
                margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: new Center(
                  child: BottomWidget(key: _bottomKey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onAction(final Action action) {
    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case AddressScreenPresenter.LocationChanged:
          action.setStateNonChanged();
          (_mapKey.currentState as GoogleMapWidgetState)?.onChange(action.getData());
          return;

        case AddressScreenPresenter.GetAddress:
          action.setStateNonChanged();
          (_bottomKey.currentState as BottomWidgetState)?.onChange(action.getData());
          return;
      }
    }
  }
}

class GoogleMapWidget extends DataWidget {
  GoogleMapWidget({Key key}) : super(key: key);

  @override
  GoogleMapWidgetState createState() => new GoogleMapWidgetState(null);
}

class GoogleMapWidgetState extends DataWidgetState<Position> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Timer _debounce;
  GoogleMapController _mapController;
  Marker _marker;

  GoogleMapWidgetState(dynamic data) : super(data);

  CameraPosition _getPosition() {
    LatLng latlng = new LatLng(55.7496, 37.6237); // Moscow
    if (getData() != null) {
      latlng = new LatLng(getData().latitude, getData().longitude);
    }
    return new CameraPosition(target: latlng, zoom: 12);
  }

  void _onCameraMove(CameraPosition position) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      SLUtil.PresenterUnion.getPresenter(AddressScreenPresenter.NAME)
          ?.addAction(new DataAction(AddressScreenPresenter.CameraMoved).setData(position.target));
    });
  }

  @override
  Widget getWidget() {
    return new GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _getPosition(),
        markers: Set<Marker>.of(_markers.values),
        onCameraMove: _onCameraMove,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        });
  }

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) _debounce.cancel();

    super.dispose();
  }

  @override
  void onChange(Position data) {
    super.onChange(data);

    LatLng latlng = new LatLng(data.latitude, data.longitude);
    if (_mapController != null) {
      _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latlng, zoom: 12)));
      if (_marker != null) {
        _marker.copyWith(positionParam: latlng);
      } else {
        _marker = new Marker(
          markerId: new MarkerId("1"),
          position: latlng,
          icon: BitmapDescriptor.fromAsset(AppUtils.getAssetImage(context, "pin.png")),
        );
        _markers[_marker.markerId] = _marker;
      }
    }
  }
}

class BottomWidget extends DataWidget {
  BottomWidget({Key key}) : super(key: key);

  @override
  BottomWidgetState createState() => new BottomWidgetState(null);
}

class BottomWidgetState extends DataWidgetState<String> {
  BottomWidgetState(String data) : super(data);

  @override
  Widget getWidget() {
    return new Text(
      StringUtils.isNullOrEmpty(getData()) ? "" : getData(),
      style: TextStyle(color: Colors.black, fontSize: 16),
    );
  }
}
