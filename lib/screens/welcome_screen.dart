import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:some_game/screens/game_screen.dart';
import 'package:some_game/widgets/static_stars_bg.dart';

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
            Colors.black.withOpacity(0.3),
            Color.fromRGBO(63, 81, 181, 0.4),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                  Navigator.pushNamed(context, GameScreen.route);
                },
                child: Text(
                  'Play',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontFamily: 'Italianno'),
                )),
            TextButton(
                onPressed: () {},
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
