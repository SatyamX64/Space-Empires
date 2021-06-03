import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/player/player.dart';
import 'package:some_game/services/game.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/utility/constants.dart';

class PlanetStats extends StatelessWidget {
  const PlanetStats();
  @override
  Widget build(BuildContext context) {
    final PlanetName _planetName =
        Provider.of<PlanetName>(context, listen: false);
    _statsText(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, opacityPrimaryColor(0.3)]),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  constraints: BoxConstraints.expand(),
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Consumer<Player>(
                    builder: (_, player, __) {
                      return SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/img/ruler/${describeEnum(player.ruler).toLowerCase()}.png',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
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
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _statsText(player
                                        .planetStats(
                                            name: _planetName)['income']
                                        .toString()),
                                    _statsText(player
                                        .planetStats(
                                            name: _planetName)['morale']
                                        .toString()),
                                    _statsText(player
                                        .planetStats(
                                            name: _planetName)['defense']
                                        .toString()),
                                  ],
                                ),
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
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    Provider.of<Game>(context, listen: false)
                        .descriptionForPlanet(_planetName),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ))
          ],
        ));
  }
}
