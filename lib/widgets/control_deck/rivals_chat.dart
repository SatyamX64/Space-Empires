import 'dart:math';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:some_game/models/player/player.dart';
import 'package:some_game/services/game.dart';
import 'package:some_game/models/rivals_model.dart';
import 'package:some_game/models/ruler_model.dart';
import 'package:some_game/widgets/gradient_dialog.dart';
import '../circle_tab_indicator.dart';

showRivalsChatMenu(BuildContext context) {
  List<Ruler> rivalsList = [];
  final Game _gameData = Provider.of<Game>(context, listen: false);
  for (Player computerPlayer in _gameData.computerPlayers) {
    rivalsList.add(computerPlayer.ruler);
  }
  return showGradientDialog(
    context: context,
    padding: 8,
    child: DefaultTabController(
      length: rivalsList.length,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: List.generate(
                rivalsList.length,
                (index) => RivalsInfo(
                  rival: rivalsList[index],
                ),
              ),
            ),
          ),
          TabBar(
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: CircleTabIndicator(color: Colors.white, radius: 3),
            tabs: List.generate(
              rivalsList.length,
              (index) => Tab(
                text: describeEnum(rivalsList[index]),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _RivalResponseProvider extends ChangeNotifier {
  String response = "So what is it ?";

  updateResponse(String value) {
    response = value;
    notifyListeners();
  }
}

class RivalsInfo extends StatelessWidget {
  RivalsInfo({this.rival});

  final Ruler rival;
  final _RivalResponseProvider _rivalResponse = _RivalResponseProvider();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _rivalResponse,
      builder: (context, _) {
        return Column(
          children: [
            _ChatOptions(
              rival: rival,
            ),
            _RivalsOpinion(
              rival: rival,
            ),
          ],
        );
      },
    );
  }
}

class _ChatOptions extends StatelessWidget {
  _ChatOptions({Key key, @required this.rival}) : super(key: key);

  final Ruler rival;

  final Map<RivalInteractions, String> _actionDesc = const {
    RivalInteractions.Trade: 'Trade',
    RivalInteractions.Help: 'Ask financial Help',
    RivalInteractions.ExtortForPeace: 'Pay me or die',
    RivalInteractions.Peace: 'Suggest Peace',
    RivalInteractions.CancelTrade: 'Cancel Trade',
    RivalInteractions.War: 'Declare War',
  };

  @override
  Widget build(BuildContext context) {
    final Game _gameData = Provider.of<Game>(context);
    final Player _currentPlayer = Provider.of<Player>(context);
    List<RivalInteractions> _possibleActions = _gameData.possibleActions(
        _gameData.relationBetweenRulers(_currentPlayer.ruler, rival));
    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black12,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Visibility(
                  visible: constraints.maxHeight >= 90,
                  child: Container(
                    height: min(120, max(constraints.maxHeight * 0.25, 72)),
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          margin: EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/img/ruler/${describeEnum(_currentPlayer.ruler).toLowerCase()}.png',
                          ),
                        ),
                      ),
                      _RelationStatusBox(
                        relation: _gameData.relationBetweenRulers(
                            _currentPlayer.ruler, rival),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: !_currentPlayer.interactionChannelStatus(rival)
                        ? Center(
                            child: Text(
                              'Enough Talkin\' for Today',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                onTap: () {
                                  _currentPlayer.closeInteractionChannel(rival);
                                  String _response =
                                      _gameData.interactWithRival(
                                          A: _currentPlayer.ruler,
                                          B: rival,
                                          action: _possibleActions[index]);
                                  Provider.of<_RivalResponseProvider>(context,
                                          listen: false)
                                      .updateResponse(_response);
                                },
                                child: Container(
                                  child: Text(
                                    _actionDesc[_possibleActions[index]],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return Divider();
                            },
                            itemCount: _possibleActions.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RivalsOpinion extends StatelessWidget {
  _RivalsOpinion({Key key, this.rival}) : super(key: key);

  final Ruler rival;
  @override
  Widget build(BuildContext context) {
    final _RivalResponseProvider _rivalResponse =
        Provider.of<_RivalResponseProvider>(context);
    return Expanded(
        child: Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              _rivalResponse.response,
              style: TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Image.asset(
              'assets/img/ruler/${describeEnum(rival).toLowerCase()}.png',
            ),
          ),
        ),
      ]),
    ));
  }
}

class _RelationStatusBox extends StatelessWidget {
  const _RelationStatusBox({Key key, this.relation}) : super(key: key);

  final RivalRelation relation;

  Color _getColor() {
    switch (relation) {
      case RivalRelation.Trade:
        return Colors.blue;
      case RivalRelation.Peace:
        return Colors.green;
      case RivalRelation.War:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context)
        .textTheme
        .headline6
        .copyWith(fontWeight: FontWeight.bold, color: _getColor());

    return Expanded(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(4)),
          child: LayoutBuilder(builder: (_, constraints) {
            return constraints.maxHeight - 28.sp > 4
                ? Column(
                    children: [
                      Text(
                        'Relation',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white54),
                      ),
                      Expanded(
                          child: Center(
                              child: FittedBox(
                        child: Text(describeEnum(relation), style: _textStyle),
                      ))),
                    ],
                  )
                : FittedBox(
                    child: Text(describeEnum(relation), style: _textStyle),
                  );
          })),
    );
  }
}
