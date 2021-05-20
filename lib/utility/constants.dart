import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color kDeepBlue = const Color(0xFF0A2D4B);
const Color kBrightOrange = const Color(0xFFE18D01);
const Color kMaroon = const Color(0xFF4B0626);

// We use custom implementation for opactiy because it is more faster then colors.opacity()

Color opacityPrimaryColor(double opacity) {
  return Color.fromRGBO(63, 81, 181, opacity);
}

Color opacityBlack(double opacity) {
  return Color.fromRGBO(0, 0, 0, opacity);
}

lockOrientation({Orientation orientation}) {
  switch (orientation) {
    case Orientation.landscape:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      return;
    case Orientation.portrait:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      return;
    default:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
  }
}
