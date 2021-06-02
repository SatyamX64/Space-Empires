import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/services/game.dart';
import 'package:some_game/screens/welcome_screen.dart';

class GameLostScreen extends StatelessWidget {
  static const route = '/game-lost-screen';
  @override
  Widget build(BuildContext context) {
    final Game _gameData = Provider.of<Game>(context,listen: false);
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                _gameData.resetAllData();
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(WelcomeScreen.route));
              },
              child: Text('You Lose'),
            ),
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }
}
