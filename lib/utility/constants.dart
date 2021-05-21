import 'package:flutter/material.dart';

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

