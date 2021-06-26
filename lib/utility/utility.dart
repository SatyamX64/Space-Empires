import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

class Utility {
  static void lockOrientation({Orientation? orientation}) {
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

  static void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Palette.deepBlue,
        textColor: Colors.white);
  }
}

extension CapExtension on String {
  String get inCaps =>
      // ignore: unnecessary_this
      this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  // ignore: unnecessary_this
  String get allInCaps => this.toUpperCase();
  // ignore: unnecessary_this
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
