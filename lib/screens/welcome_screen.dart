import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:some_game/screens/game_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const route = '/welcome-screen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/img/stars_bg.png')),
        ),
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            Lottie.asset('assets/animations/stars.json'),
            Positioned(
              right: size.width * 5 / 60,
              top: size.height / 2,
              child: Lottie.asset('assets/animations/saturn.json',
                  height: size.width / 3, width: size.width / 3),
            ),
            Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.3),
                    Theme.of(context).primaryColor.withOpacity(0.4)
                  ]),
                )),
            Positioned(
              right: -size.width * 5 / 60,
              bottom: size.width * 3 / 60,
              child: Lottie.asset('assets/animations/mars.json',
                  height: size.width * 4 / 9, width: size.width * 4 / 9),
            ),
            Positioned(
              left: -size.width / 4,
              bottom: size.width / 10,
              child: Lottie.asset('assets/animations/xeno.json',
                  height: size.width * 5 / 6, width: size.width * 5 / 6),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SPACE EMPIRE',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontFamily: 'Astral', fontSize: size.width / 10),
                  ),
                  SizedBox(
                    height: size.width / 3,
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
            ),
          ],
        ),
      ),
    );
  }
}
