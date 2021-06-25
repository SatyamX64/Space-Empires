import 'package:flutter/material.dart';

class Palette {
  static const Color deepBlue = Color(0xFF0A2D4B);
  static const Color brightOrange = Color(0xFFE18D01);
  static const Color maroon = Color(0xFF4B0626);
}
// We use custom implementation for opactiy because it is more Optimized then colors.opacity()

Color opacityIndigo(double opacity) {
  return Color.fromRGBO(63, 81, 181, opacity);
}

Color opacityBlack(double opacity) {
  return Color.fromRGBO(0, 0, 0, opacity);
}

const String portfolioLink = "https://www.satyamx64.tech";
const String githubLink = "https://www.github.com/SatyamX64/space_empires.git";
