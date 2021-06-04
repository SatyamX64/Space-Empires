import 'package:flutter/material.dart';

class Palette {
  static const Color deepBlue = const Color(0xFF0A2D4B);
  static const Color brightOrange = const Color(0xFFE18D01);
  static const Color maroon = const Color(0xFF4B0626);
}
// We use custom implementation for opactiy because it is more Optimized then colors.opacity()

Color opacityIndigo(double opacity) {
  return Color.fromRGBO(63, 81, 181, opacity);
}

Color opacityBlack(double opacity) {
  return Color.fromRGBO(0, 0, 0, opacity);
}
