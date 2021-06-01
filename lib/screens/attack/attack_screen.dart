import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/formation_generator.dart';
import 'package:some_game/widgets/attack/battlefield.dart';
import 'package:some_game/widgets/attack/control_panel.dart';
import 'package:some_game/widgets/gradient_dialog.dart';
import 'package:some_game/widgets/static_stars_bg.dart';
import 'package:sizer/sizer.dart';

class AttackScreen extends StatelessWidget {
  static const route = '/attack-screen';
  AttackScreen({this.planet, this.attacker});
  final Planet planet;
  final Player attacker;

  @override
  Widget build(BuildContext context) {
    _quitGame() {
      showGradientDialog(
          context: context,
          color: Palette.maroon,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Leaving a battle in between huh? Got too hard',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/img/planets/${describeEnum(planet.name).toLowerCase()}.png',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(child: Container()),
              Text(
                'You Serious ??',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    return Future.value(true);
                  },
                  child: Text('Yes I am')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    return Future.value(false);
                  },
                  child: Text('Na, I was joking')),
            ],
          ));
    }

    final Orientation _orientation = MediaQuery.of(context).orientation;
    final FormationProvider _formationProvider = FormationProvider();
    final GameData _gameData = Provider.of<GameData>(context);
    final Player _defender = _gameData.playerForPlanet(planet.name);

    _attackerDefenderImage() {
      return SizedBox(
        height: 60.sp,
        child: Row(
          children: [
            Image.asset(
              'assets/img/ruler/${describeEnum(attacker.ruler).toLowerCase()}.png',
            ),
            Spacer(),
            Image.asset(
              'assets/img/ruler/${describeEnum(_defender.ruler).toLowerCase()}.png',
            ),
          ],
        ),
      );
    }

    _spaceLights() {
      return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              opacityBlack(0.3),
              Palette.maroon,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ));
    }

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text('Attack'),
          ),
          body: Stack(
            children: [
              StaticStarsBackGround(),
              _spaceLights(),
              MultiProvider(
                providers: [
                  // To keep track of weather current Player is attacker or defender
                  Provider<bool>.value(
                      value: _gameData.currentPlayer.ruler == attacker.ruler),
                  ChangeNotifierProvider<Player>.value(
                    value: attacker,
                  ),
                  ChangeNotifierProvider<Planet>.value(
                    value: planet,
                  ),
                  ChangeNotifierProvider<FormationProvider>.value(
                      value: _formationProvider)
                ],
                builder: (_, __) => _orientation == Orientation.landscape
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(child: Battlefield()),
                                // Divider(
                                //   color: Colors.white38,
                                // ),
                                // _attackerDefenderImage(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ControlPanel(),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _attackerDefenderImage(),
                          Divider(
                            color: Colors.white38,
                          ),
                          Expanded(
                            flex: 3,
                            child: Battlefield(),
                          ),
                          Expanded(
                            flex: 2,
                            child: ControlPanel(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        onWillPop: _quitGame);
  }
}
