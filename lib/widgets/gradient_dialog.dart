import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

Future showGradientDialog({
  required BuildContext context,
  Widget? child,
  double padding = 16.0,
  Color? color,
}) async{
  final size = MediaQuery.of(context).size;
  final Orientation orientation = (size.width / size.height > 1.7)
      ? Orientation.landscape
      : Orientation.portrait;
  return (await showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.size,
      barrierDismissible: true,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
                alignment: Alignment.center,
                height: orientation == Orientation.landscape
                    ? size.height * 0.90
                    : size.height * 0.6,
                width: orientation == Orientation.landscape
                    ? size.width * 0.5
                    : size.width * 0.8,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.8),
                    color ?? Theme.of(context).primaryColor.withOpacity(0.8)
                  ]),
                ),
                child: child),
          ),
        );
      })) ?? Future.value(false);
}
