import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psb/app/screen/address/AddressScreenPresenter.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenState extends WidgetState<AddressScreenWidget> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _mapController = Completer();
  StreamController<double> _streamController = StreamController.broadcast();
  ScrollController _scrollController = new ScrollController();
  double position = 64;
  double childHeight = 63;

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
                  position = MediaQuery.of(context).size.height - details.globalPosition.dy;
                  if (position < 64) {
                    position = 64;
                  }
                  childHeight = position - 1;
                  _streamController.add(position);
                },
                behavior: HitTestBehavior.translucent,
                child: new Container(
                  color: Color(0xffffffff),
                  height: position,
                  width: double.infinity,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        height: 1,
                        color: Color(0xffc9c9c9),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        height: childHeight,
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
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
          ),
        ],
      );
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
