import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/widgets/static_stars_bg.dart';

import 'ether_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const route = '/welcome-screen';

  _animatedStars() {
    return Lottie.asset('assets/animations/stars.json');
  }

  _spaceLights() {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            opacityBlack(0.3),
            opacityPrimaryColor(0.4),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final gameData = Provider.of<GameData>(context,listen: false);
    _menu() {
      return Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SPACE EMPIRE',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontFamily: 'Astral'),
            ),
            SizedBox(
              height: size.height / 6,
            ),
            TextButton(
                onPressed: () {
                  // gameData.initCurrentPlayer(Ruler.Zapp);
                  // Navigator.pushNamed(context, IntroScreen.route);
                },
                child: Text(
                  'Play',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontFamily: 'Italianno'),
                )),
            TextButton(
                onPressed: () {
                  final Orientation orientation = MediaQuery.of(context).orientation;
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => EtherScreen(orientation)));
                },
                child: Text(
                  'Story',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontFamily: 'Italianno'),
                )),
          ],
        ),
      );
    }

    _saturn() {
      return Positioned(
        right: -max(size.width, size.height) / 4,
        bottom: -max(size.width, size.height) / 8,
        child: Lottie.asset('assets/animations/saturn.json',
            height: max(size.width, size.height) / 2,
            width: max(size.width, size.height) / 2),
      );
    }

    _xeno() {
      return Positioned(
        left: -max(size.width, size.height) / 4,
        bottom: 0,
        child: Lottie.asset('assets/animations/xeno.json',
            height: max(size.width, size.height) / 2,
            width: max(size.width, size.height) / 2),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _animatedStars(),
          _spaceLights(),
          _saturn(),
          _xeno(),
          _menu(),
        ],
      ),
    );
  }
}
