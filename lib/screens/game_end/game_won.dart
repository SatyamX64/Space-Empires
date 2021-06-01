import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';

import '../welcome_screen.dart';

class GameWonScreen extends StatelessWidget {
  static const route = '/game-won-screen';
  @override
  Widget build(BuildContext context) {
    final GameData _gameData = Provider.of<GameData>(context, listen: false);
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                _gameData.resetAllData();
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(WelcomeScreen.route));
              },
              child: Text('You Win'),
            ),
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }
}
