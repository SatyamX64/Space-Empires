import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utility {
  static lockOrientation({Orientation orientation}) {
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
}
