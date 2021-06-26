import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:space_empires/services/player/player.dart';

import '../../services/planet/planet.dart';
import '/screens/attack/attack_screen.dart';
import '/services/game.dart';
import '/utility/constants.dart';
import '/utility/utility.dart';
import '/widgets/gradient_dialog.dart';

Future<void> showAttackMenu(BuildContext context) {
  return showGradientDialog(
    context: context,
    child: Column(
      children: [
        Text(
          'Attack',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(child: LayoutBuilder(
          builder: (context, constraints) {
            return _EnemyPlanets(constraints: constraints);
          },
        )),
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Your Forces',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const _MyForce(),
      ],
    ),
  );
}

class _EnemyPlanets extends StatelessWidget {
  const _EnemyPlanets({Key? key,required this.constraints}) : super(key: key);

  final BoxConstraints constraints;

  Widget _planetCard(String planetName) {
    return Container(
      width: constraints.maxWidth * 0.6,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Image.asset('assets/img/planets/$planetName.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Game _gameData = Provider.of<Game>(context, listen: false);
    final Player _player = Provider.of<Player?>(context, listen: false)!;
    final List<Planet> _availablePlanets =
        _gameData.enemyPlanetsFor(_player.ruler);
    return _availablePlanets.isEmpty
        ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.black26),
            child: const Text(
              'No Enemy Planets',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          )
        : Stack(
            children: [
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black26,
                ),
                child: CarouselSlider.builder(
                  options: CarouselOptions(),
                  itemCount: _availablePlanets.length,
                  itemBuilder: (BuildContext context, int index, _) =>
                      GestureDetector(
                    onTap: () {
                      if (!_player.canAttack) {
                        Utility.showToast(
                            'Nahh !! Too tired after the last one');
                      } else if (_availablePlanets[index].inWar) {
                        Utility.showToast(
                            'That one is already under attack by someone');
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(AttackScreen.route, arguments: {
                          'planet': _availablePlanets[index],
                          'attacker':
                              Provider.of<Player?>(context, listen: false)!,
                        });
                      }
                    },
                    child: _planetCard(
                        describeEnum(_availablePlanets[index].name)),
                  ),
                ),
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_left)),
              const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_right)),
            ],
          );
  }
}

class _MyForce extends StatelessWidget {
  const _MyForce({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Player _player = Provider.of<Player?>(context, listen: false)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: List.generate(
          _player.ships.length,
          (index) => _MyForceCard(
            name: describeEnum(_player.ships.keys.toList()[index]),
            quantity:
                _player.militaryShipCount(_player.ships.keys.toList()[index]),
          ),
        ),
      ),
    );
  }
}

class _MyForceCard extends StatelessWidget {
  const _MyForceCard({
    Key? key,
    required this.name,
    required this.quantity,
  }) : super(key: key);

  final String name;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              height:
                  min(max(size.width, size.height) / 10, constraints.maxWidth),
              width:
                  min(max(size.width, size.height) / 10, constraints.maxWidth),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.deepBlue),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/img/ships/attack/$name.png'),
                ),
              ),
            );
          }),
          Text(quantity.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
