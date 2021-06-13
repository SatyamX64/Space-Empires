import 'dart:math';
import 'package:space_empires/services/player/player.dart';
import '/models/attack_ships_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/game.dart';
import '../../services/planet/planet_model.dart';
import 'package:sizer/sizer.dart';
import '/screens/attack/attack_conclusion_screen.dart';
import '/screens/game_end/game_lost.dart';
import '/screens/game_end/game_won.dart';
import '/utility/constants.dart';
import '../../services/formation_generator.dart';

class ControlPanel extends StatefulWidget {
  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel>
    with TickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  GlobalKey _attackButtonKey = GlobalKey();
  AnimationController _animationController;
  Animation<double> _animation;
  CarouselController formationCarouselController = CarouselController();
  @override
  void initState() {
    super.initState();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  showOverlay(String attackPoint, String defensePoint) async {
    OverlayState _overlayState = Overlay.of(context);
    RenderBox _renderBox = _attackButtonKey.currentContext.findRenderObject();
    Offset offset = _renderBox.localToGlobal(Offset.zero);
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
          top: offset.dy - _renderBox.size.height / 2 - _animation.value * 60,
          left: offset.dx,
          width: _renderBox.size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: 1 - _animation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        attackPoint,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.lime, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        defensePoint,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.lime, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          )),
    );
    _animationController.addListener(() {
      _overlayState.setState(() {});
    });
    _overlayState.insert(_overlayEntry);
    _animationController.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        if (_overlayEntry != null) {
          _overlayEntry.remove();
          _overlayEntry = null;
        }
      }
    });
  }

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
    final Game _gameData = Provider.of<Game>(context, listen: false);
    final FormationProvider _formationProvider =
        Provider.of<FormationProvider>(context, listen: false);

    List<int> bestDefenderPosition() {
      int maxLikeabilityFactor = 0;
      List<int> bestFormation = _formationProvider.formations[0];
      for (List<int> formation in _formationProvider.formations) {
        List<int> damageOutputs = _planet.attack(formation);
        int likeablilityFactor = _attacker.damageDoneByFormation(damageOutputs);
        if (likeablilityFactor > maxLikeabilityFactor) {
          maxLikeabilityFactor = likeablilityFactor;
          bestFormation = formation;
        }
      }
      return bestFormation;
    }

    List<int> bestAttackerPosition() {
      int maxLikeabilityFactor = 0;
      List<int> bestFormation = _formationProvider.formations[0];
      for (List<int> formation in _formationProvider.formations) {
        List<int> damageOutputs = _attacker.attack(formation);
        int likeablilityFactor = _planet.likeabilityFactor(damageOutputs);
        if (likeablilityFactor > maxLikeabilityFactor) {
          maxLikeabilityFactor = likeablilityFactor;
          bestFormation = formation;
        }
      }
      return bestFormation;
    }

    Map<String, bool> _canDamage() {
      // Checks if Attacker / Defender can damage the other party or not
      // Eg : If both parties have only 1 battleship/orbital left
      // Then no one will ever win and battle will end as stalemate
      // Attacker will retreat without further lose
      int likabilityDefense = 0;
      for (List<int> formation in _formationProvider.formations) {
        List<int> damageOutputs = _attacker.attack(formation);
        int likeablilityFactor = _planet.likeabilityFactor(damageOutputs);
        if (likeablilityFactor > likabilityDefense) {
          likabilityDefense = likeablilityFactor;
        }
      }
      int likeabilityAttack = 0;
      for (List<int> formation in _formationProvider.formations) {
        List<int> damageOutputs = _planet.attack(formation);
        int likeablilityFactor = _attacker.damageDoneByFormation(damageOutputs);
        if (likeablilityFactor > likeabilityAttack) {
          likeabilityAttack = likeablilityFactor;
        }
      }
      print(' Like : $likeabilityAttack : $likabilityDefense');
      return {
        'defender': likabilityDefense > 0,
        'attacker': likeabilityAttack > 0,
      };
    }

    _goToConclusionScreen(String message) {
      if (_overlayEntry != null) {
        _overlayEntry.remove();
        _overlayEntry = null;
      }
      Navigator.pushReplacementNamed(context, AttackConclusionScreen.route,
          arguments: message);
    }

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
                        flex: 3,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              '${_planet.defense}',
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
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            'Defense',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )),
                  _baseCard(
                      child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Center(
                              child: CarouselSlider(
                                carouselController: formationCarouselController,
                                items: List.generate(
                                  pow(kAttackShipsData.length,
                                      kAttackShipsData.length),
                                  (index) => Center(
                                    child: FittedBox(
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
                                  GestureDetector(
                                      onTap: () {
                                        formationCarouselController
                                            .previousPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.linear);
                                      },
                                      child: Icon(Icons.arrow_left)),
                                  GestureDetector(
                                      onTap: () {
                                        formationCarouselController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                      child: Icon(Icons.arrow_right)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          child: Text(
                            'Formation',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              )),
          Expanded(
            flex: 3,
            child: Container(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.all(2.sp),
                child: ElevatedButton(
                  key: _attackButtonKey,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Palette.maroon),
                  ),
                  onPressed: () {
                    // TODO : All the Attack related logic is here

                    final playerFormation = _formationProvider.currentFormation;
                    final computerPosition = _isPlayerAttacker
                        ? bestAttackerPosition()
                        : bestDefenderPosition();
                    final attackFormation =
                        _isPlayerAttacker ? playerFormation : computerPosition;
                    final defenseFormation =
                        !_isPlayerAttacker ? playerFormation : computerPosition;

                    int _initialAttackShips =
                        List.from(_attacker.allShips.values)
                            .fold(0, (p, c) => p + c);
                    int _initialDefenseShips =
                        List.from(_planet.allShips.values)
                            .fold(0, (p, c) => p + c);

                    List<int> damageOutputsDefense =
                        _planet.attack(defenseFormation);
                    List<int> damageOutputsAttacker =
                        _attacker.attack(attackFormation);
                    int attackShipsLeft =
                        _attacker.defend(damageOutputsDefense);
                    int defenseShipsLeft =
                        _planet.defend(damageOutputsAttacker);
                    showOverlay(
                        '-${_initialAttackShips - attackShipsLeft} Ships',
                        '-${_initialDefenseShips - defenseShipsLeft} Ships');
                    Map<String, bool> canDamage = _canDamage();
                    // If Both attack and defense ships become  0, then attack is considered failed
                    if (attackShipsLeft == 0) {
                      _goToConclusionScreen(
                          'The Planet Successfully defended itself');
                    } else if (defenseShipsLeft == 0) {
                      if (_overlayEntry != null) {
                        _overlayEntry.remove();
                        _overlayEntry = null;
                      }
                      _gameData.changeOwnerOfPlanet(
                          newRuler: _attacker.ruler, name: _planet.name);
                      if (_gameData.wonGame) {
                        Navigator.pushReplacementNamed(
                          context,
                          GameWonScreen.route,
                        );
                      } else if (_gameData.lostGame) {
                        Navigator.pushReplacementNamed(
                          context,
                          GameLostScreen.route,
                        );
                      } else {
                        _goToConclusionScreen(
                            'The planet succumbed to its attacker');
                      }
                    } else if ((!_isPlayerAttacker && !canDamage['attacker']) ||
                        (!canDamage['attacker'] && !canDamage['defender'])) {
                      // If computer is attacker and it can't damage it retreats, defender doesn't matter unless 0
                      // If no one can further damage the other, then attacker retreats
                      _goToConclusionScreen(
                          'The Attacker has retreated, Planet is Safe');
                      // attacker gives up
                    }
                    // If player is attacker and can't damage, defender will destory it eventually or they retreat
                  },
                  child: FittedBox(
                    child: Text(
                      'A T T A C K',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
