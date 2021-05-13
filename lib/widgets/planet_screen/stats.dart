import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:some_game/models/planet_model.dart';

class PlanetStats extends StatelessWidget {
  const PlanetStats({Key key, Planet planet})
      : _planet = planet,
        super(key: key);

  final Planet _planet;
  @override
  Widget build(BuildContext context) {
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
            gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.3)
            ]),
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints.expand(),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/img/avatar/${describeEnum(_planet.ruler).toLowerCase()}.png',
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
                              _statsText('Defence : '),
                              _statsText('Trade : '),
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
                              _statsText(_planet.income.toString()),
                              _statsText(_planet.morale.toString() + '%'),
                              _statsText(_planet.defence.toString()),
                              _statsText(_planet.trade.toString() + '%'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Card(
              color: Colors.black12,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Text(
                  _planet.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ))
          ],
        ));
  }
}
