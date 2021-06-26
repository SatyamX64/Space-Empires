import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_empires/services/player/player.dart';
import '/services/game.dart';
import '/utility/utility.dart';
import '/widgets/gradient_dialog.dart';

Future<void> showStatsMenu(BuildContext context) {
  return showGradientDialog(
      context: context,
      child: Column(
        children: [
          Text(
            'Stats',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const _ResourceAllocator(),
          const _RivalsOpinion()
        ],
      ));
}

class _ResourceAllocator extends StatelessWidget {
  const _ResourceAllocator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Player player = Provider.of<Player?>(context)!;
    return Expanded(
        flex: 3,
        child: Container(
          margin: const EdgeInsets.all(4),
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
                    '${player.income} \$',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  )),
            ],
          ),
        ));
  }
}

class _RivalsOpinion extends StatelessWidget {
  const _RivalsOpinion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This Shall Come from GameData, since it is a relative constraint
    final Game _gameData = Provider.of<Game>(context, listen: false);
    final Player _player = Provider.of<Player?>(context, listen: false)!;
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
      child: SingleChildScrollView(
        child: Text(
          _gameData.getRivalsOpinion(_player.ruler),
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontFamily: 'Italianno',
                // fontWeight: FontWeight.w600
              ),
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}

class _InfoBar extends StatelessWidget {
  const _InfoBar({required this.text, required  this.value});
  Text _statsText(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  final String text;
  final Widget value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: _statsText(text.inCaps),
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
  final void Function() increment;
  final void Function() decrement;
  final int? value;

  const _PlusMinus(
      {required this.decrement,
      required this.increment,
      required this.value});

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
            margin: const EdgeInsets.all(4),
            child: Text(
              value.toString(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
