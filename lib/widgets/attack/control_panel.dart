import 'dart:math';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:sizer/sizer.dart';
import 'package:some_game/screens/attack/attack_conclusion_screen.dart';
import 'package:some_game/utility/formation_generator.dart';

class ControlPanel extends StatelessWidget {
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
    final FormationProvider _formationProvider =
        Provider.of<FormationProvider>(context, listen: false);
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
                      child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '${_planet.defense}',
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                      Text(
                        'Defense',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
                  _baseCard(
                      child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
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
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.arrow_left),
                                  Icon(Icons.arrow_right)
                                ],
                              ),
                            ),
                          ],
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
                // _baseCard(
                //   child: Image.asset(
                //     'assets/img/planets/${describeEnum(_planet.name).toLowerCase()}.png',
                //     fit: BoxFit.contain,
                //   ),
                // ),
                _baseCard(
                  child: GestureDetector(
                    onTap: () {
                      final computerPosition = _formationProvider.formations[5];
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
                      List<int> damageOutputsAttacker =
                          _attacker.attack(attackFormation);
                      int attackShipsLeft =
                          _attacker.defend(damageOutputsDefense);
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
                                newRuler: _attacker.ruler, name: _planet.name);
                        Navigator.pushReplacementNamed(
                            context, AttackConclusionScreen.route,
                            arguments: 'The planet succumbed to its attacker');
                      }
                    },
                    child: Container(
                      child: Text(
                        'Attack',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
