import 'package:flutter/material.dart';
import 'package:get/get.dart';

final double zfinalDeviceHeigh = Get.height;
final double zfinalDeviceWidth = Get.width;
final double zfinalTextScaleFactor = Get.textScaleFactor;

final double zadjustedDeviceHeight = 1200;
final double zgivenDeviceHeight = 1080;
final double zgivenDeviceWidth = 1938;
late double zfinalHeight;
late double zfinalWidth;
late double zfinalFontSize;

setCurrentHeight(double heigh, BuildContext context) {
  double current_height = MediaQuery.of(context).size.height;
  zfinalHeight = heigh * current_height / zgivenDeviceHeight;
  return zfinalHeight;
}

setCurrentWidth(
  double width,
  BuildContext context,
) {
  double current_width = MediaQuery.of(context).size.width;
  zfinalWidth = width * current_width / zgivenDeviceWidth;
  return zfinalWidth;
}

setFontSize(double fontSize, BuildContext context) {
  double current_height = MediaQuery.of(context).size.height;
  double current_width = MediaQuery.of(context).size.width;
  zfinalFontSize = (current_height * current_width) *
      fontSize *
      1.5 /
      (zgivenDeviceHeight * zgivenDeviceWidth);
  return zfinalFontSize;
}

const blackColor = Color(0xFF323e48);
