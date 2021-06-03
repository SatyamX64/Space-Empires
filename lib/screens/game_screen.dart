import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/player/player.dart';
import 'package:some_game/screens/game_end/game_lost.dart';
import 'package:some_game/screens/game_end/game_won.dart';
import 'package:some_game/widgets/control_deck/global_news.dart';
import '../services/game.dart';
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
import 'attack/attack_screen.dart';

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
                  'assets/img/ruler/${describeEnum(Provider.of<Player>(context, listen: false).ruler).toLowerCase()}.png',
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
                    Provider.of<Game>(context, listen: false).resetAllData();
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
            backgroundColor: Palette.deepBlue,
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

class _NextTurnFAB extends StatefulWidget {
  const _NextTurnFAB({
    Key key,
  }) : super(key: key);

  @override
  __NextTurnFABState createState() => __NextTurnFABState();
}

class __NextTurnFABState extends State<_NextTurnFAB>
    with TickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  GlobalKey _fabKey = GlobalKey();
  AnimationController _animationController;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  showOverlay(String value) async {
    OverlayState _overlayState = Overlay.of(context);
    RenderBox _renderBox = _fabKey.currentContext.findRenderObject();
    Offset offset = _renderBox.localToGlobal(Offset.zero);
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
          top: offset.dy - _renderBox.size.height / 2 - _animation.value * 60,
          left: offset.dx,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: 1 - _animation.value,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                )),
          )),
    );
    _animationController.addListener(() {
      _overlayState.setState(() {});
    });
    _overlayState.insert(_overlayEntry);
    _animationController.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        if (_overlayEntry != null) {
          _overlayEntry.remove();
          _overlayEntry = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Game _gameData = Provider.of<Game>(context, listen: false);
    return SizedBox(
      height: 80,
      width: 80,
      key: _fabKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientFAB(
            onTap: () async {
              var oncomingAttack = _gameData.nextTurn();
              if (_gameData.lostGame) {
                Navigator.of(context).pushNamed(GameLostScreen.route);
              } else if (_gameData.wonGame) {
                Navigator.of(context).pushNamed(GameWonScreen.route);
              } else {
                if (oncomingAttack != null) {
                  await Navigator.of(context)
                      .pushNamed(AttackScreen.route, arguments: {
                    'planet': oncomingAttack['planet'],
                    'attacker':
                        _gameData.playerFromRuler(oncomingAttack['ruler']),
                  });
                } else {
                  if (_gameData.galacticNews.isNotEmpty) {
                    await showGlobalNews(context);
                    _gameData.clearNews();
                  }
                  showOverlay('+${_gameData.currentPlayer.income}\$');
                }
              }
            },
            toolTip: 'Next Turn',
            image: 'assets/img/control_deck/next.svg'),
      ),
    );
  }
}
