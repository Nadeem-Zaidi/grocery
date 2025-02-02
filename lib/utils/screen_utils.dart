import 'package:flutter/material.dart';

class ScreenUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }
}
