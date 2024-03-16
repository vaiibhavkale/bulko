import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double? screenWidth ;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical ;
  static dynamic screenOrientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight / 100;
    screenOrientation = _mediaQueryData.orientation;
  }
}
