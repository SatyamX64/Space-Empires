import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:some_game/screens/ether_screen.dart';
import 'package:some_game/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    final Orientation orientation = MediaQuery.of(context).orientation;
    if (_seen) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => EtherScreen(orientation)));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(':)',style: TextStyle(color: Colors.white24),)),
    );
  }
}
