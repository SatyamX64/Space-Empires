import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:space_empires/services/player/player.dart';

import '../../services/formation_generator.dart';
import '../../services/planet/planet.dart';
import '/screens/game_end/game_lost.dart';
import '/services/game.dart';
import '/utility/constants.dart';
import '/widgets/attack/battlefield.dart';
import '/widgets/attack/control_panel.dart';
import '/widgets/gradient_dialog.dart';
import '/widgets/static_stars_bg.dart';

class AttackScreen extends StatelessWidget {
  static const route = '/attack-screen';
  AttackScreen({required this.planet, required this.attacker}) {
    planet.inWar = true;
    attacker.canAttack = false;
  }
  final Planet planet;
  final Player attacker;

  @override
  Widget build(BuildContext context) {
    final Orientation _orientation = MediaQuery.of(context).orientation;
    final FormationProvider _formationProvider = FormationProvider();
    final Game _gameData = Provider.of<Game>(context);
    final Player _defender = _gameData.playerForPlanet(planet.name);

    Future<bool> _quitGame() async {
      final res = await showGradientDialog(
        context: context,
        color: Palette.maroon,
        child: Column(
          children: [
            Text(
              'Leaving a battle in between huh? Got too hard',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/img/planets/${describeEnum(planet.name)}.png',
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            Text(
              'You Serious ??',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            TextButton(
                onPressed: () {
                  if (_gameData.currentPlayer.ruler == attacker.ruler) {
                    attacker.destroyMilitary(0.2);
                    return Navigator.of(context).pop(true);
                  } else {
                    _gameData.changeOwnerOfPlanet(
                        newRuler: attacker.ruler, planetName: planet.name);
                    if (_gameData.lostGame) {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                        context,
                        GameLostScreen.route,
                      );
                    } else {
                      return Navigator.of(context).pop(true);
                    }
                  }
                },
                child: const Text('Yes I am')),
            TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
                child: const Text('Na, I was joking')),
          ],
        ),
      );
      if (res is bool) {
        return res;
      } else {
        return false;
      }
    }

    Widget _attackerDefenderImage() {
      return SizedBox(
        height: 60.sp,
        child: Row(
          children: [
            Image.asset(
              'assets/img/ruler/${describeEnum(attacker.ruler)}.png',
            ),
            const Spacer(),
            Image.asset(
              'assets/img/ruler/${describeEnum(_defender.ruler)}.png',
            ),
          ],
        ),
      );
    }

    Widget _spaceLights() {
      return Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              opacityBlack(0.3),
              Palette.maroon,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ));
    }

    return WillPopScope(
      onWillPop: _quitGame,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Attack'),
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
                        const Expanded(
                          child: Battlefield(),
                        ),
                        Expanded(
                          child: ControlPanel(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _attackerDefenderImage(),
                        const Divider(
                          color: Colors.white38,
                        ),
                        const Expanded(
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
    );
  }
}
