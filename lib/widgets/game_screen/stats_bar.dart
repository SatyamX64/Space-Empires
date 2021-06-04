import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/player/player.dart';
import 'package:some_game/screens/help/instructions-screen.dart';
import 'package:some_game/services/game.dart';
import 'package:some_game/utility/constants.dart';
import 'package:sizer/sizer.dart';

class StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Chip(
              backgroundColor: Colors.pink[600],
              elevation: 6.0,
              avatar: Center(
                child: FittedBox(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(8.0),
              label: Consumer<Game>(
                builder: (_, gameData, __) {
                  return Text('Days : ${gameData.days}',
                      style: TextStyle(fontWeight: FontWeight.bold));
                },
              ),
            ),
            SizedBox(
              width: 16.sp,
            ),
            Chip(
              backgroundColor: Colors.green[900],
              avatar: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: FittedBox(
                      child: Text(
                    '\$',
                    style: TextStyle(
                        color: Palette.deepBlue, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(8.0),
              label: Consumer<Player>(
                builder: (_, player, __) {
                  return Text(
                    '${player.money}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(InstructionScreen.route);
              },
              child: Chip(
                backgroundColor: Colors.blue[900],
                elevation: 6.0,
                shadowColor: Colors.grey[60],
                padding: EdgeInsets.all(8.0),
                label: Text(
                  'Info',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
