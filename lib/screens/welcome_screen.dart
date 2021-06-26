import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '/utility/constants.dart';
import '/widgets/static_stars_bg.dart';
import 'help/info_screen.dart';
import 'story/story_i.dart';

class WelcomeScreen extends StatelessWidget {
  static const route = '/welcome-screen';

  Widget get _animatedStars {
    return Lottie.asset('assets/animations/stars.json');
  }

  Widget get _spaceLights {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            opacityBlack(0.3),
            opacityIndigo(0.4),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget _menu() {
      return Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SPACE EMPIRES',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontFamily: 'Astral'),
            ),
            SizedBox(
              height: size.height / 6,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, InfoScreen.route,arguments: false);
                },
                child: Text(
                  'Play',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontFamily: 'Italianno'),
                )),
            TextButton(
                onPressed: () {
                  final Orientation orientation =
                      MediaQuery.of(context).orientation;
                  Navigator.of(context).pushReplacementNamed(StoryScreenI.route,
                      arguments: orientation);
                },
                child: Text(
                  'Story',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontFamily: 'Italianno'),
                )),
          ],
        ),
      );
    }

    Widget _saturn() {
      return Positioned(
        right: -size.longestSide / 4,
        bottom: -size.longestSide / 8,
        child: Lottie.asset('assets/animations/saturn.json',
            height: size.longestSide / 2, width: size.longestSide / 2),
      );
    }

    Widget _purplePlanet() {
      return Positioned(
        left: -size.longestSide / 4,
        bottom: 0,
        child: Lottie.asset('assets/animations/xeno.json',
            height: size.longestSide / 2, width: size.longestSide / 2),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _animatedStars,
          _spaceLights,
          _saturn(),
          _purplePlanet(),
          _menu(),
        ],
      ),
    );
  }
}
