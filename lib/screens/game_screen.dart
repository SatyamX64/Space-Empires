import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_data.dart';
import '../models/player_model.dart';
import '../widgets/gradient_dialog.dart';
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
    final Size _size = MediaQuery.of(context).size;
    final Orientation _orientation = MediaQuery.of(context).orientation;
    final double _statsBarHeight = _orientation == Orientation.landscape
        ? _size.height * 0.1
        : _size.height * 0.05;
    final double _controlDeckHeight = _size.height * 0.10;

     _quitGame() {

      showGradientDialog(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Silence sets in the universe.. as one of the big 4 ruler has decided to quit',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/img/avatar/${describeEnum(Provider.of<Player>(context, listen: false).ruler).toLowerCase()}.png',
                ),
              ),
              Expanded(child: Container()),
              Text(
                'You Serious ??',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Provider.of<GameData>(context, listen: false)
                        .resetAllData();
                    return Future.value(true);
                  },
                  child: Text('Yes I am')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    return Future.value(false);
                  },
                  child: Text('Na, I was joking')),
            ],
          ));
    }

    return WillPopScope(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
            showLabel: _controlDeckHeight > 48 ? false : true,
            height: _controlDeckHeight,
            iconSize: 48,
            items: [
              ControlDeckItem(text: 'Attack'),
              ControlDeckItem(text: 'Military'),
              ControlDeckItem(text: 'Stats'),
              ControlDeckItem(text: 'Rivals'),
            ],
          ),
          body: Column(
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: _statsBarHeight,
                      maxWidth: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).viewPadding.right),
                  child: StatsBar()),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          _controlDeckHeight -
                          _statsBarHeight -
                          MediaQuery.of(context).viewPadding.bottom,
                      maxWidth: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).viewPadding.right),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SolarSystem(),
                  ))
            ],
          ),
        ),
        onWillPop: _quitGame);
  }
}

class _NextTurnFAB extends StatelessWidget {
  const _NextTurnFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameData _gameData = Provider.of<GameData>(context, listen: false);
    return SizedBox(
      height: 80,
      width: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientFAB(
            onTap: () {
              _gameData.nextTurn();
            },
            toolTip: 'Next Turn',
            image: 'assets/img/control_deck/next.svg'),
      ),
    );
  }
}
