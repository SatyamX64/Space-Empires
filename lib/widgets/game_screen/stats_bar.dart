import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:space_empires/screens/help/info_screen.dart';
import 'package:space_empires/services/player/player.dart';

import '/services/game.dart';
import '/utility/constants.dart';

class StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Chip(
              backgroundColor: Colors.pink[600],
              elevation: 6.0,
              avatar: const Center(
                child: FittedBox(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              shadowColor: Colors.grey[60],
              padding: const EdgeInsets.all(8.0),
              label: Consumer<Game>(
                builder: (_, gameData, __) {
                  return Text('Days : ${gameData.days}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold));
                },
              ),
            ),
            SizedBox(
              width: 16.sp,
            ),
            Chip(
              backgroundColor: Colors.green[900],
              avatar: const Center(
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
              padding: const EdgeInsets.all(8.0),
              label: Consumer<Player?>(
                builder: (_, player, __) {
                  return Text(
                    '${player!.money}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(InfoScreen.route, arguments: true);
              },
              child: Chip(
                backgroundColor: Colors.blue[900],
                elevation: 6.0,
                shadowColor: Colors.grey[60],
                padding: const EdgeInsets.all(8.0),
                label: Text(
                  'Info',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
