import 'package:flutter/material.dart';

class ScreenUtil {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
  }
}
