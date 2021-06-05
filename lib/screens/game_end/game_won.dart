import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/game.dart';
import '/utility/constants.dart';

import '../welcome_screen.dart';

class GameWonScreen extends StatelessWidget {
  static const route = '/game-won-screen';
  @override
  Widget build(BuildContext context) {
    final Game _gameData = Provider.of<Game>(context, listen: false);
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: Image.asset('assets/img/gifs/win.gif'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Palette.deepBlue,
            tooltip: 'Restart',
            child: Icon(
              Icons.forward,
              color: Colors.white,
            ),
            onPressed: () {
              _gameData.resetAllData();
              Navigator.of(context)
                  .popUntil(ModalRoute.withName(WelcomeScreen.route));
            },
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }
}
