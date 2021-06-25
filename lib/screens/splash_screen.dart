import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/welcome_screen.dart';
import 'story/story_i.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash-screen';
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  Future checkFirstSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final _seen = prefs.getBool('seen') ?? false;
    final Orientation orientation = MediaQuery.of(context).orientation;
    if (_seen) {
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.route);
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context)
          .pushReplacementNamed(StoryScreenI.route, arguments: orientation);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
