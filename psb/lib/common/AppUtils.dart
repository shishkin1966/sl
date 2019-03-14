import 'package:flutter/material.dart';

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
}
