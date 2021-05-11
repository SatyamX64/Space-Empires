import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

showRivalsChatMenu(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.size,
      barrierDismissible: true,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: DefaultTabController(
            length: 3,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: size.height * 0.6,
                width: size.width * 0.8,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.8),
                    Theme.of(context).primaryColor.withOpacity(0.8)
                  ]),
                ),
                child: Column(
                  children: [_ScoreAllocator(), _Finance(), _RivalsOpinion()],
                ),
              ),
            ),
          ),
        );
      });
}

class _ScoreAllocator extends StatelessWidget {
  _ScoreAllocator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
    ));
  }
}

class _Finance extends StatelessWidget {
  _Finance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
    ));
  }
}

class _RivalsOpinion extends StatelessWidget {
  _RivalsOpinion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
    ));
  }
}
