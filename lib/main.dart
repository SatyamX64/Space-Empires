import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import './screens/character_selection_screen.dart';
import './screens/game_end/game_lost.dart';
import './screens/game_end/game_won.dart';
import './screens/game_screen.dart';
import './screens/planet_screen.dart';
import './screens/splash_screen.dart';
import './screens/story/story_i.dart';
import './screens/story/story_ii.dart';
import './screens/welcome_screen.dart';
import 'models/planet_model.dart';
import 'screens/attack/attack_conclusion_screen.dart';
import 'screens/attack/attack_screen.dart';
import 'screens/help/info_screen.dart';
import 'screens/story/story_iii.dart';
import 'services/game.dart';
import 'services/planet/planet.dart';
import 'services/player/player.dart';
import 'utility/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // To make the Game fullscreen
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Game>.value(
          value: Game(),
        ),

        // It is lazily build, i.e unless someone requests it, it won't be created
        // It is requested for first Time on gameScreen (as we navigate from characterSelectionScreen)
        // As soon as gameScreen is called create is called
        // But since we notify GameData too (in characterSelectionScreen)
        // So update is called too
        // finally the value obtained is provided in gameScreen
        ChangeNotifierProxyProvider<Game, Player?>(
          update: (_, game, __) {
            return game.currentPlayer;
          },
          create: (ctx) {
            return null;
          },
        ),
      ],
      builder: (_, __) {
        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Space Empires',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              primaryColor: Colors.indigo,
              accentColor: Palette.deepBlue,
              textTheme: TextTheme(
                headline4: TextStyle(fontSize: 28.sp, color: Colors.white),
                bodyText2: TextStyle(fontSize: 12.sp, color: Colors.white),
                headline5: TextStyle(fontSize: 18.sp, color: Colors.white),
                headline6: TextStyle(fontSize: 16.sp, color: Colors.white),
                button: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
                size: 18.sp,
              ),
              tabBarTheme: TabBarTheme(
                labelPadding: EdgeInsets.all(4.sp),
                labelStyle:
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(4.sp)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Palette.deepBlue),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            home: SplashScreen(),
            routes: {
              SplashScreen.route: (ctx) => SplashScreen(),
              StoryScreenII.route: (ctx) => StoryScreenII(),
              StoryScreenIII.route: (ctx) => StoryScreenIII(),
              WelcomeScreen.route: (ctx) => WelcomeScreen(),
              CharacterSelectionScreen.route: (ctx) =>
                  CharacterSelectionScreen(),
              GameScreen.route: (ctx) => GameScreen(),
              AttackConclusionScreen.route: (ctx) => AttackConclusionScreen(),
              GameLostScreen.route: (ctx) => GameLostScreen(),
              GameWonScreen.route: (ctx) => GameWonScreen(),
            },
            onGenerateRoute: (routeSettings) {
              if (routeSettings.name == InfoScreen.route) {
                return MaterialPageRoute(
                    builder: (context) => InfoScreen(
                        characterSelected: routeSettings.arguments! as bool));
              } else if (routeSettings.name == PlanetScreen.route) {
                final PlanetName _planetName =
                    routeSettings.arguments! as PlanetName;
                return MaterialPageRoute(
                  builder: (context) => PlanetScreen(_planetName),
                );
              } else if (routeSettings.name == StoryScreenI.route) {
                final Orientation _orientation =
                    routeSettings.arguments! as Orientation;
                return MaterialPageRoute(
                  builder: (context) => StoryScreenI(_orientation),
                );
              } else if (routeSettings.name == AttackScreen.route) {
                final args = routeSettings.arguments! as Map;
                final Planet _planet = args['planet'] as Planet;
                final Player _attacker = args['attacker'] as Player;
                return MaterialPageRoute(
                  builder: (context) =>
                      AttackScreen(attacker: _attacker, planet: _planet),
                );
              }
              return null;
            },
          );
        });
      },
    );
  }
}
