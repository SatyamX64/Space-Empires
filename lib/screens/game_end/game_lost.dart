import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/game.dart';
import '/screens/welcome_screen.dart';

class GameLostScreen extends StatelessWidget {
  static const route = '/game-lost-screen';
  @override
  Widget build(BuildContext context) {
    final Game _gameData = Provider.of<Game>(context, listen: false);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Image.asset('assets/img/gifs/lose.gif'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFDB091D),
            tooltip: 'Restart',
            child: Icon(Icons.change_circle_outlined),
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
