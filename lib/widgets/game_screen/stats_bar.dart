import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/player/player.dart';
import 'package:some_game/models/ruler_model.dart';
import 'package:some_game/services/game.dart';
import 'package:some_game/screens/help/help-screen.dart';
import 'package:some_game/utility/constants.dart';

class StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black, opacityIndigo(0.4), Colors.black],
            stops: [0.0, 0.7, 1.0]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Consumer<Player>(
              builder: (_, player, __) {
                return Text(
                  '${player.money} 💲 |  ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                );
              },
            ),
            Consumer<Game>(
              builder: (_, gameData, __) {
                return Text('Days : ${gameData.days}/$kGameDays',
                    style: TextStyle(fontWeight: FontWeight.w600));
              },
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    'Help',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(HelpScreen.route);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
