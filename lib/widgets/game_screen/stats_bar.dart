import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/utility/constants.dart';

class StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black, opacityPrimaryColor(0.4), Colors.black],
            stops: [0.0, 0.7, 1.0]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Player>(
              builder: (_, player, __) {
                return Text(
                  '${player.money} 💲 |  ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                );
              },
            ),
            Consumer<GameData>(
              builder: (_, gameData, __) {
                return Text('Days : ${gameData.days}/365',
                    style: TextStyle(fontWeight: FontWeight.w600));
              },
            ),
          ],
        ),
      ),
    );
  }
}
