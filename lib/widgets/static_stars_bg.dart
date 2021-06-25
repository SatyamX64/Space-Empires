import 'package:flutter/material.dart';

class StaticStarsBackGround extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return RotatedBox(
      quarterTurns: orientation == Orientation.landscape ? 1 : 0,
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/img/stars_bg.png')),
        ),
      ),
    );
  }
}
