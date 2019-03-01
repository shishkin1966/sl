import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psb/app/screen/address/AddressScreenPresenter.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/ui/WidgetState.dart';
import 'package:rubber/rubber.dart';

class AddressScreenState extends WidgetState<AddressScreenWidget> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  RubberAnimationController _animationController;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _animationController = RubberAnimationController(
        vsync: this,
        dismissable: true,
        lowerBoundValue: AnimationControllerValue(pixel: 80),
        upperBoundValue: AnimationControllerValue(pixel: 400),
        duration: Duration(milliseconds: 200));
    super.initState();
  }

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
          new GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
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
