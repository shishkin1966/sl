import 'package:flutter/material.dart';

class WithoutGlowBehavior extends ScrollBehavior {
  @override
  buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
