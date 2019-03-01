import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psb/app/screen/address/AddressScreenData.dart';
import 'package:psb/app/screen/address/AddressScreenPresenter.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenState extends WidgetState<AddressScreenWidget> with SingleTickerProviderStateMixin {
  GoogleMapController _mapController;
  StreamController<double> _streamController = StreamController.broadcast();
  ScrollController _scrollController = new ScrollController();
  double _bottomPosition = 64;
  double _bottomHeight = 63;
  AddressScreenData _data = new AddressScreenData();

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
        bottomSheet: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshot) => GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  _bottomPosition = MediaQuery.of(context).size.height - details.globalPosition.dy;
                  if (_bottomPosition < 64) {
                    _bottomPosition = 64;
                  }
                  _bottomHeight = _bottomPosition - 1;
                  _streamController.add(_bottomPosition);
                },
                behavior: HitTestBehavior.translucent,
                child: new Container(
                  color: Color(0xffffffff),
                  height: _bottomPosition,
                  width: double.infinity,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        height: 1,
                        color: Color(0xffc9c9c9),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        height: _bottomHeight,
                        child: new NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[];
                          },
                          body: new Container(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        ),
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
          new Positioned(
            top: 0,
            left: 0,
            height: constraints.maxHeight - 64,
            width: constraints.maxWidth,
            child: new GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              trackCameraPosition: true,
              mapType: MapType.normal,
              initialCameraPosition: _getPosition(),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
        ],
      );
    });
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
          }
          break;
      }
    }
  }
}
