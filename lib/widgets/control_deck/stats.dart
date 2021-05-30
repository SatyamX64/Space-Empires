import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/utility/utility.dart';
import 'package:some_game/widgets/gradient_dialog.dart';

showStatsMenu(BuildContext context) {
  return showGradientDialog(
      context: context,
      child: Column(
        children: [
          Text(
            'Stats',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          _ResourceAllocator(),
          _RivalsOpinion()
        ],
      ));
}

class _ResourceAllocator extends StatelessWidget {
  _ResourceAllocator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Player player = Provider.of<Player>(context);
    return Expanded(
        flex: 3,
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black12,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        player.statsList.length,
                        (index) => _InfoBar(
                              text: describeEnum(player.statsList[index]),
                              value: _PlusMinus(
                                  increment: () {
                                    try {
                                      player.increaseStat(
                                          player.statsList[index]);
                                    } catch (e) {
                                      Utility.showToast(e.toString());
                                    }
                                  },
                                  decrement: () {
                                    try {
                                      player.decreaseStat(
                                          player.statsList[index]);
                                    } catch (e) {
                                      Utility.showToast(e.toString());
                                    }
                                  },
                                  value: player
                                      .statValue(player.statsList[index])),
                            )),
                  ),
                ),
              ),
              _InfoBar(
                  text: 'Total',
                  value: Text(
                    '${player.income} 💲',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ));
  }
}

class _RivalsOpinion extends StatelessWidget {
  _RivalsOpinion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This Shall Come from GameData, since it is a relative constraint
    final GameData _gameData = Provider.of<GameData>(context, listen: false);
    final Player _player = Provider.of<Player>(context, listen: false);
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
      child: SingleChildScrollView(
        child: Text(_gameData.getRivalsOpinion(_player.ruler),
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontFamily: 'Italianno',
                  // fontWeight: FontWeight.w600
                )),
      ),
    ));
  }
}

class _InfoBar extends StatelessWidget {
  _InfoBar({this.text, this.value});
  _statsText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  final text;
  final value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: _statsText(text),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: value,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlusMinus extends StatelessWidget {
  final Function increment;
  final Function decrement;
  final int value;

  _PlusMinus(
      {@required this.decrement,
      @required this.increment,
      @required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: increment,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(4),
            child: Text(
              value.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: decrement,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove),
            ),
          ),
        ],
      ),
    );
  }
}
