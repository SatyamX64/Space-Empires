import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:space_empires/services/player/player.dart';
import '../../services/planet/planet_model.dart';
import '../../services/formation_generator.dart';
import '/widgets/attack/formation_painter.dart';
import 'package:sizer/sizer.dart';

class Battlefield extends StatelessWidget {
  const Battlefield({Key key}) : super(key: key);

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
                      child: Image.asset(
                        'assets/img/ships/attack/${describeEnum(List.from(_attacker.allShips.keys)[index]).toLowerCase()}.png',
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
    // Listens to Provider of type Planet (The Planet that is being attacked on)
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
                      child: Image.asset(
                        'assets/img/ships/defense/${describeEnum(List.from(_planet.allShips.keys)[index]).toLowerCase()}.png',
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

  _formationPaths(bool _attackMode) {
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
      return Container(
        child: Row(
          children: [
            _attackShips(constraints),
            _formationPaths(_isCurrentPlayerAttacker),
            _defenseShips(constraints)
          ],
        ),
      );
    });
  }
}
