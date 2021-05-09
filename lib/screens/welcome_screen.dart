import 'package:flutter/material.dart';
import 'package:some_game/screens/game_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const route = '/welcome-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Space Empire',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 120,),  
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, GameScreen.route);
                },
                child: Text(
                  'Play',
                  style: Theme.of(context).textTheme.headline5,
                )),
            TextButton(
                onPressed: () {},
                child: Text(
                  'Story',
                  style: Theme.of(context).textTheme.headline5,
                )),   
          ],
        ),
      ),
    );
  }
}
