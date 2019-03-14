import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psb/app/screen/address/AddressScreenData.dart';
import 'package:psb/app/screen/address/AddressScreenPresenter.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/AppColor.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenState extends WidgetState<AddressScreenWidget> with SingleTickerProviderStateMixin {
  static const double RolledBottomMenuHeight = 65;

  GoogleMapController _mapController;
  double _bottomPosition = RolledBottomMenuHeight;
  AddressScreenData _data = new AddressScreenData();
  Marker _marker;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

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
        backgroundColor: Color(0x00000000),
        body: new Builder(builder: (BuildContext context) {
          widgetContext = context;
          return SafeArea(top: true, child: _getWidget());
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
            color: Color(0xffEEF5FF),
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
      height: constraints.maxHeight - _bottomPosition <= 0
          ? constraints.maxHeight
          : constraints.maxHeight - _bottomPosition,
      width: constraints.maxWidth,
      child: new GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _getPosition(),
        markers: Set<Marker>.of(_markers.values),
        onCameraMove: _onCameraMove,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }

  Widget _showBottomMenu(BuildContext context, BoxConstraints constraints) {
    return new Positioned(
      top: constraints.maxHeight - _bottomPosition,
      height: _bottomPosition,
      left: 0,
      width: constraints.maxWidth,
      child: new Container(
        color: Colors.white,
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
                _bottomPosition -= notification.dragDetails.delta.dy * 4;
                if (_bottomPosition < RolledBottomMenuHeight) {
                  _bottomPosition = RolledBottomMenuHeight;
                }
                if (_bottomPosition >= constraints.maxHeight) {
                  _bottomPosition = constraints.maxHeight;
                }
                setState(() {});
              }
            }
          },
          child: new ListView(
            children: <Widget>[
              new Container(
                height: 1,
                color: Color(AppColor.DividerDark),
              ),
              new Container(
                height: _bottomPosition - 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  CameraPosition _getPosition() {
    LatLng l = new LatLng(55.7496, 37.6237); // Moscow
    if (_data.location != null) {
      l = new LatLng(_data.location.latitude, _data.location.longitude);
    }
    return new CameraPosition(target: l, zoom: 12);
  }

  @override
  void onAction(final Action action) {
    if (action is DataAction) {
      String actionName = action.getName();
      switch (actionName) {
        case AddressScreenPresenter.LocationChanged:
          _data.location = action.getData();
          LatLng l = new LatLng(_data.location.latitude, _data.location.longitude);
          if (_mapController != null) {
            _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: l, zoom: 12)));
            if (_marker != null) {
              _marker.copyWith(positionParam: l);
            } else {
              double ratio = MediaQuery.of(context).devicePixelRatio;
              String icon = 'assets/images/pin.png';
              if (ratio >= 2.0) {
                icon = 'assets/images/2x/pin.png';
              }
              _marker = new Marker(
                markerId: new MarkerId("1"),
                position: l,
                icon: BitmapDescriptor.fromAsset(icon),
              );
              _markers[_marker.markerId] = _marker;
            }
          }
          break;
      }
    }
  }

  void _onCameraMove(CameraPosition position) {
    getPresenter().addAction(new DataAction(AddressScreenPresenter.CameraMoved).setData(position));
  }
}
