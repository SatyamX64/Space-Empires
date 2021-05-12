import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

showGradientDialog({@required BuildContext context, Widget child,double padding : 16.0}) {
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
          child: Center(
            child: Container(
                alignment: Alignment.center,
                height: size.height * 0.6,
                width: size.width * 0.8,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.8),
                    Theme.of(context).primaryColor.withOpacity(0.8)
                  ]),
                ),
                child: child),
          ),
        );
      });
}
