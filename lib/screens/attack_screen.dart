import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:some_game/models/defense_ships_model.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/screens/attack_conclusion_screen.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/formation_generator.dart';
import 'package:some_game/widgets/gradient_dialog.dart';
import 'package:some_game/widgets/static_stars_bg.dart';
import 'package:sizer/sizer.dart';

class _FormationProvider extends ChangeNotifier {
  final List<List<int>> _formations;
  int _selectedFormation;

  _FormationProvider(this._formations) {
    this._selectedFormation = 0;
  }

  List<int> get currentFormation {
    return _formations[_selectedFormation];
  }

  List<List<int>> get formations {
    return _formations;
  }

  changeFormation(index) {
    _selectedFormation = index;
    notifyListeners();
  }
}

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
          color: kMaroon,
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

    final Orientation orientation = MediaQuery.of(context).orientation;
    final FormationGenerator formationGenerator = FormationGenerator();
    final _FormationProvider _formationProvider =
        _FormationProvider(formationGenerator.formations);
    final GameData _gameData = Provider.of<GameData>(context);
    final Player defender = _gameData.playerForPlanet(planet.name);

    _attackerDefenderImage() {
      return SizedBox(
        height: 60.sp,
        child: Row(
          children: [
            Image.asset(
              'assets/img/avatar/${describeEnum(attacker.ruler).toLowerCase()}.png',
            ),
            Spacer(),
            Image.asset(
              'assets/img/avatar/${describeEnum(defender.ruler).toLowerCase()}.png',
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
              kMaroon,
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
                  Provider<bool>.value(
                      value: _gameData.currentPlayer.ruler == attacker.ruler),
                  ChangeNotifierProvider<Player>.value(
                    value: attacker,
                  ),
                  ChangeNotifierProvider<Planet>.value(
                    value: planet,
                  ),
                  ChangeNotifierProvider<_FormationProvider>.value(
                      value: _formationProvider)
                ],
                builder: (_, __) => orientation == Orientation.landscape
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(child: _Battlefield()),
                                Divider(
                                  color: Colors.white38,
                                ),
                                _attackerDefenderImage(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: _ControlPanel(),
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
                            child: _Battlefield(),
                          ),
                          Expanded(
                            child: _ControlPanel(),
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

class _ControlPanel extends StatelessWidget {
  _baseCard({Widget child}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(2.sp),
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
            color: Colors.black45, borderRadius: BorderRadius.circular(4.sp)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isPlayerAttacker = Provider.of<bool>(context);
    final Planet _planet = Provider.of<Planet>(context, listen: false);
    final Player _attacker = Provider.of<Player>(context, listen: false);
    final _FormationProvider _formationProvider =
        Provider.of<_FormationProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(16.sp),
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  _baseCard(
                    child: Image.asset(
                      'assets/img/planets/${describeEnum(_planet.name).toLowerCase()}.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  _baseCard(
                      child: Column(
                    children: [
                      Expanded(
                        child: CarouselSlider(
                          items: List.generate(
                            pow(kAttackShipsData.length,
                                kAttackShipsData.length),
                            (index) => Center(
                              child: Text(
                                '${index + 1}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            onPageChanged: (index, _) {
                              _formationProvider.changeFormation(index);
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Formation',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
                ],
              )),
          Expanded(
              flex: 3,
              child: Row(
                children: [
                  _baseCard(
                    child: Text(
                      '${_planet.defense}',
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  _baseCard(
                    child: GestureDetector(
                      onTap: () {
                        final computerPosition =
                            _formationProvider.formations[5];
                        final playerFormation =
                            _formationProvider.currentFormation;

                        final attackFormation = _isPlayerAttacker
                            ? playerFormation
                            : computerPosition;
                        final defenseFormation = !_isPlayerAttacker
                            ? playerFormation
                            : computerPosition;
                        List<int> damageOutputsDefense =
                            _planet.attack(defenseFormation);
                        int attackShipsLeft =
                            _attacker.defend(damageOutputsDefense);
                        List<int> damageOutputsAttacker =
                            _attacker.attack(attackFormation);
                        int defenseShipsLeft =
                            _planet.defend(damageOutputsAttacker);
                        if (attackShipsLeft == 0) {
                          Navigator.pushReplacementNamed(
                              context, AttackConclusionScreen.route,
                              arguments:
                                  'The planet successfully defended itself');
                        } else if (defenseShipsLeft == 0) {
                          Provider.of<GameData>(context, listen: false)
                              .changeOwnerOfPlanet(
                                  newRuler: _attacker.ruler,
                                  name: _planet.name);
                          Navigator.pushReplacementNamed(
                              context, AttackConclusionScreen.route,
                              arguments:
                                  'The planet succumbed to its attacker');
                        }
                      },
                      child: Container(
                        child: Text(
                          'Attack',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class _Battlefield extends StatelessWidget {
  const _Battlefield({Key key}) : super(key: key);

  _attackShips(BoxConstraints constraints) {
    // Listens to Provider of type Player (not currentPlayer but a new attacker provider)
    return Consumer<Player>(
      builder: (_, _attacker, __) {
        final double iconSize =
            (constraints.maxHeight / _attacker.allShips.length - 32.sp);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _attacker.allShips.length,
            (index) => Padding(
              padding: EdgeInsets.all(16.sp),
              child: Container(
                height: iconSize,
                width: iconSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/img/ships/attack/${describeEnum(List.from(_attacker.allShips.keys)[index]).toLowerCase()}.svg',
                      ),
                    ),
                    Text(
                        '${_attacker.allShips[List.from((_attacker.allShips.keys))[index]]}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _defenseShips(BoxConstraints constraints) {
    // Listens to Provider of type Player (not currentPlayer but a new attacker provider)
    return Consumer<Planet>(
      builder: (_, _planet, __) {
        final double iconSize =
            (constraints.maxHeight / _planet.allShips.length - 32.sp);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _planet.allShips.length,
            (index) => Padding(
              padding: EdgeInsets.all(16.sp),
              child: Container(
                height: iconSize,
                width: iconSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/img/ships/defense/${describeEnum(List.from(_planet.allShips.keys)[index]).toLowerCase()}.svg',
                      ),
                    ),
                    Text(
                        '${_planet.allShips[List.from((_planet.allShips.keys))[index]]}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _formationPaths(bool attackMode) {
    return Consumer<_FormationProvider>(
      builder: (_, _target, ___) {
        return Expanded(
            child: CustomPaint(
                painter: attackMode
                    ? AttackerFormationPainter(
                        formation: _target.currentFormation)
                    : DefenderFormationPainter(
                        formation: _target.currentFormation),
                child: Container()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentPlayerAttacker = Provider.of<bool>(context);
    return LayoutBuilder(builder: (_, constraints) {
      return Container(
        child: Row(
          children: [
            _attackShips(constraints),
            _formationPaths(isCurrentPlayerAttacker),
            _defenseShips(constraints)
          ],
        ),
      );
    });
  }
}

class AttackerFormationPainter extends CustomPainter {
  final List<int> formation;
  AttackerFormationPainter({@required this.formation})
      : assert(formation.length == kAttackShipsData.length &&
            formation.length == kDefenseShipsData.length);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    List<Offset> startingPoints = [];
    List<Offset> endPoints = [];

    for (int i = 1; i < formation.length * 2; i += 2) {
      startingPoints.add(Offset(0, size.height / (formation.length * 2) * i));
      endPoints
          .add(Offset(size.width, size.height / (formation.length * 2) * i));
    }

    for (int i = 0; i < formation.length; i++) {
      canvas.drawLine(startingPoints[i], endPoints[formation[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DefenderFormationPainter extends CustomPainter {
  final List<int> formation;
  DefenderFormationPainter({@required this.formation})
      : assert(formation.length == kAttackShipsData.length &&
            formation.length == kDefenseShipsData.length);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    List<Offset> startingPoints = [];
    List<Offset> endPoints = [];

    for (int i = 1; i < formation.length * 2; i += 2) {
      startingPoints.add(Offset(0, size.height / (formation.length * 2) * i));
      endPoints
          .add(Offset(size.width, size.height / (formation.length * 2) * i));
    }

    for (int i = 0; i < formation.length; i++) {
      canvas.drawLine(endPoints[i], startingPoints[formation[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
