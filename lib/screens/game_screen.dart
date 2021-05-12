import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utility/constants.dart';
import '../widgets/control_deck.dart';
import '../widgets/control_deck/attack.dart';
import '../widgets/control_deck/military.dart';
import '../widgets/control_deck/rivals_chat.dart';
import '../widgets/control_deck/stats.dart';
import '../widgets/game_screen/solar_system.dart';
import '../widgets/game_screen/stats_bar.dart';
import '../widgets/gradient_fab.dart';

class GameScreen extends StatelessWidget {
  static const route = '/game-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _NextTurnFAB(),
      bottomNavigationBar: ControlDeck(
        onPressed: (index) {
          switch (index) {
            case 0:
              showAttackMenu(context);
              return;
            case 1:
              showMilitaryMenu(context);
              return;
            case 2:
              showStatsMenu(context);
              return;
            case 3:
              showRivalsChatMenu(context);
              return;
          }
        },
        backgroundColor: kDeepBlue,
        notchedShape: CircularNotchedRectangle(),
        showText: false,
        iconSize: 48,
        height: 72,
        items: [
          ControlDeckItem(text: 'Attack'),
          ControlDeckItem(text: 'Military'),
          ControlDeckItem(text: 'Stats'),
          ControlDeckItem(text: 'Rivals'),
        ],
      ),
      body: Column(
        children: [
          StatsBar(),
          SolarSystem(),
        ],
      ),
    );
  }
}

class _NextTurnFAB extends StatelessWidget {
  const _NextTurnFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientFAB(
            onTap: () {},
            toolTip: 'Next Turn',
            image: 'assets/img/control_deck/next.svg'),
      ),
    );
  }
}
