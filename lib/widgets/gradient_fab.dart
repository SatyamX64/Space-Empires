import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utility/constants.dart';

class GradientFAB extends StatelessWidget {
  const GradientFAB({
    Key key,
    @required this.onTap,
    @required this.toolTip,
    @required this.image,
  }) : super(key: key);

  final Function onTap;
  final String toolTip;
  final String image;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: onTap,
      tooltip: toolTip,
      child: Container(
        alignment: Alignment.center,
        width: 60,
        height: 60,
        child: SvgPicture.asset(
          image,
          height: 48,
          width: 48,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Colors.black, Theme.of(context).primaryColor])),
      ),
      backgroundColor: Palette.brightOrange,
    );
  }
}
