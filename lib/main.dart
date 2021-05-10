import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:some_game/screens/game_screen.dart';
import 'package:some_game/screens/planet_screen.dart';
import 'package:some_game/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.indigo,
          accentColor: Color(0xFFE18D01),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0A2D4B)),
          ))),
      initialRoute: WelcomeScreen.route,
      routes: {
        WelcomeScreen.route: (ctx) => WelcomeScreen(),
        GameScreen.route: (ctx) => GameScreen(),
        PlanetScreen.route: (ctx) => PlanetScreen(),
      },
    );
  }
}
