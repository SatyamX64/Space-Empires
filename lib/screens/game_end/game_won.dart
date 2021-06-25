import 'package:flutter/material.dart';

import '../welcome_screen.dart';
import '/utility/constants.dart';

class GameWonScreen extends StatelessWidget {
  static const route = '/game-won-screen';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/img/gifs/win.gif'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Palette.deepBlue,
          tooltip: 'Restart',
          onPressed: () {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(WelcomeScreen.route));
          },
          child: const Icon(
            Icons.forward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
