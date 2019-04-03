import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppUtils {
  static String getAssetImage(BuildContext context, String file) {
    double ratio = MediaQuery.of(context).devicePixelRatio;
    if (ratio < 2) {
      return 'assets/images/' + file;
    } else if (ratio > 2.7) {
      return 'assets/images/3x/' + file;
    } else {
      return 'assets/images/2x/' + file;
    }
  }

  static Widget getVectorImage(String file,
      {double width, double height, Color color}) {
    return new SvgPicture.asset(
      'assets/vector/' + file,
      width: width,
      height: height,
      color: color,
    );
  }
}
