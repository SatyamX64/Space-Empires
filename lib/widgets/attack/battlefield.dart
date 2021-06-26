import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:space_empires/services/player/player.dart';

import '../../services/formation_generator.dart';
import '../../services/planet/planet.dart';
import '/widgets/attack/formation_painter.dart';

class Battlefield extends StatelessWidget {
  const Battlefield({Key? key}) : super(key: key);

  Widget _attackShips(BoxConstraints constraints) {
    // Listens to Provider of type Player (not currentPlayer but a new attacker provider)
    return Consumer<Player>(
      builder: (_, _attacker, __) {
        final double iconSize =
            constraints.maxHeight / _attacker.ships.length - 32.sp;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _attacker.ships.length,
            (index) => Padding(
              padding: EdgeInsets.all(16.sp),
              child: SizedBox(
                height: iconSize,
                width: iconSize,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/img/ships/attack/${describeEnum(_attacker.ships.keys.toList()[index])}.png',
                      ),
                    ),
                    Text(
                        '${_attacker.ships[_attacker.ships.keys.toList()[index]]}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _defenseShips(BoxConstraints constraints) {
    // Listens to Provider of type Planet (The Planet that is being attacked on)
    return Consumer<Planet>(
      builder: (_, _planet, __) {
        final double iconSize =
            constraints.maxHeight / _planet.ships.length - 32.sp;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _planet.ships.length,
            (index) => Padding(
              padding: EdgeInsets.all(16.sp),
              child: SizedBox(
                height: iconSize,
                width: iconSize,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/img/ships/defense/${describeEnum(_planet.ships.keys.toList()[index])}.png',
                      ),
                    ),
                    Text(
                        '${_planet.ships[_planet.ships.keys.toList()[index]]}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _formationPaths(bool _attackMode) {
    return Consumer<FormationProvider>(
      builder: (_, _formationProvider, ___) {
        return Expanded(
            child: CustomPaint(
                painter: _attackMode
                    ? AttackerFormationPainter(
                        formation: _formationProvider.currentFormation)
                    : DefenderFormationPainter(
                        formation: _formationProvider.currentFormation),
                child: Container()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isCurrentPlayerAttacker = Provider.of<bool>(context);
    return LayoutBuilder(builder: (_, constraints) {
      return Row(
        children: [
          _attackShips(constraints),
          _formationPaths(_isCurrentPlayerAttacker),
          _defenseShips(constraints)
        ],
      );
    });
  }
}
