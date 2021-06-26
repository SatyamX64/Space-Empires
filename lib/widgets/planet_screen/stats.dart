import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:space_empires/models/planet_model.dart';
import 'package:space_empires/services/player/player.dart';

import '/services/game.dart';
import '/utility/constants.dart';

class PlanetStats extends StatelessWidget {
  const PlanetStats();
  @override
  Widget build(BuildContext context) {
    final PlanetName _planetName =
        Provider.of<PlanetName>(context, listen: false);
    Widget _statsText(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.black, opacityIndigo(0.3)]),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  constraints: const BoxConstraints.expand(),
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Consumer<Player?>(
                    builder: (_, player, __) {
                      return SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/img/ruler/${describeEnum(player!.ruler)}.png',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _statsText('Income : '),
                                  _statsText('Morale : '),
                                  _statsText('Defense : '),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _statsText(player
                                      .planetStats(name: _planetName)['income']
                                      .toString()),
                                  _statsText(
                                      '${(player.planetStats(name: _planetName)['morale']! / 10).toStringAsFixed(2)} %'),
                                  _statsText(player
                                      .planetStats(name: _planetName)['defense']
                                      .toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
            Expanded(
                child: Card(
              color: Colors.black12,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    Provider.of<Game>(context, listen: false)
                        .descriptionForPlanet(_planetName),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ))
          ],
        ));
  }
}
