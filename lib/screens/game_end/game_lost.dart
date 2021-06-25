import 'package:flutter/material.dart';
import '/screens/welcome_screen.dart';

class GameLostScreen extends StatelessWidget {
  static const route = '/game-lost-screen';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset('assets/img/gifs/lose.gif'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFDB091D),
          tooltip: 'Restart',
          onPressed: () {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(WelcomeScreen.route));
          },
          child: const Icon(Icons.change_circle_outlined),
        ),
      ),
    );
  }
}
