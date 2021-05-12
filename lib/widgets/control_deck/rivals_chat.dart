import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:some_game/models/rivals_model.dart';
import 'package:some_game/widgets/gradient_dialog.dart';

import '../circle_tab_indicator.dart';

showRivalsChatMenu(BuildContext context) {
  return showGradientDialog(
    context: context,
    padding: 8,
    child: DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Expanded(
              child: TabBarView(
                  children: List.generate(
                      rivalsList.length,
                      (index) => RivalsInfo(
                            rival: rivalsList[index],
                          )))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TabBar(
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: CircleTabIndicator(color: Colors.white, radius: 3),
                tabs: List.generate(
                    rivalsList.length,
                    (index) => Tab(
                          text: describeEnum(rivalsList[index].ruler),
                        ))),
          ),
        ],
      ),
    ),
  );
}

class RivalsInfo extends StatelessWidget {
  RivalsInfo({this.rival});

  final Rival rival;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScoreAllocator(
          rival: rival,
        ),
        _RivalsOpinion(
          rival: rival,
        ),
      ],
    );
  }
}

class _ScoreAllocator extends StatelessWidget {
  _ScoreAllocator({Key key, @required this.rival}) : super(key: key);

  final Rival rival;

  List _actions = [
    'Give a gift',
    'Trade',
    'Ask financial help',
    'Extort Money',
    'Declare War',
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black12,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        margin: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/img/avatar/zapp.png',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          _MoodStatusBox(
                            mood: rival.mood,
                          ),
                          _RelationStatusBox(
                            relation: rival.relation,
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                          itemBuilder: (ctx, index) {
                            return Container(
                                child: Text(
                              _actions[index],
                              style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white70),
                            ));
                          },
                          separatorBuilder: (ctx, index) {
                            return Divider();
                          },
                          itemCount: _actions.length),
                    )),
              ],
            )));
  }
}

class _RivalsOpinion extends StatelessWidget {
  _RivalsOpinion({Key key, this.rival}) : super(key: key);

  final Rival rival;
  @override
  Widget build(BuildContext context) {
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
        
            child: Text('No',style: TextStyle(fontWeight: FontWeight.w600),),
          ),
        ),
        Expanded(
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            margin: EdgeInsets.all(4),
            child: Image.asset(
              'assets/img/avatar/${describeEnum(rival.ruler).toLowerCase()}.png',
            ),
          ),
        ),
      ]),
    ));
  }
}

class _MoodStatusBox extends StatelessWidget {
  const _MoodStatusBox({Key key, this.mood}) : super(key: key);

  final RivalMood mood;

  Color _getColor() {
    // switch (mood) {
    //   case RivalMood.Cordial:
    //     return Colors.blue;
    //   case RivalMood.Disregard:
    //     return Colors.green;
    //   case RivalMood.Resents:
    //     return Colors.red;
    //   case RivalMood.Scared:
    //     return Colors.yellow;
    // }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: _getColor());

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            Text(
              'Mood',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white54),
            ),
            Expanded(
                child:
                    Center(child: Text(describeEnum(mood), style: _textStyle))),
          ],
        ),
      ),
    );
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
    TextStyle _textStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: _getColor());

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            Text(
              'Relation',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white54),
            ),
            Expanded(
                child: Center(
                    child: Text(describeEnum(relation), style: _textStyle))),
          ],
        ),
      ),
    );
  }
}
