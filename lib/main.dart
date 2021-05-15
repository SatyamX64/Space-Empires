import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:some_game/screens/game_screen.dart';
import 'package:some_game/screens/planet_screen.dart';
import 'package:some_game/screens/welcome_screen.dart';
import 'package:sizer/sizer.dart';
import 'utility/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
   
    return Sizer(builder: (context, orientation, deviceType) { 
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.indigo,
            accentColor: kDeepBlue,
            textTheme: TextTheme(
              headline4: TextStyle(fontSize: 28.sp),
              bodyText2: TextStyle(fontSize: 12.sp),
              headline5: TextStyle(fontSize: 18.sp),
              headline6: TextStyle(fontSize: 16.sp),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 18.sp,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kDeepBlue),
            ))),
        initialRoute: WelcomeScreen.route,
        routes: {
          WelcomeScreen.route: (ctx) => WelcomeScreen(),
          GameScreen.route: (ctx) => GameScreen(),
          PlanetScreen.route: (ctx) => PlanetScreen(),
        },
      );
    });
  }
}
