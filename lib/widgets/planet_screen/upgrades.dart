import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:some_game/models/upgrade_model.dart';
import 'package:sizer/sizer.dart';

class PlanetUpgrades extends StatelessWidget {
  PlanetUpgrades({
    Key key,
  }) : super(key: key);

  _getSize(double n, double w, double h) {
    double sw, sh;
    var pw = (sqrt(n * w / h)).ceilToDouble();
    if ((pw * h / w).floorToDouble() * pw < n)
      sw = h / (pw * h / w).ceilToDouble();
    else
      sw = w / pw;
    var ph = (sqrt(n * h / w)).ceilToDouble();
    if ((ph * w / h).floorToDouble() * ph < n)
      sh = w / (w * ph / h).ceilToDouble();
    else
      sh = h / ph;
    return max(sw, sh);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        alignment: Alignment.center,
        child: Wrap(
          children: List.generate(upgradesList.length, (index) {
            return _UpgradeCard(
                upgrade: upgradesList[index],
                side: _getSize(upgradesList.length.toDouble(),
                    constraints.maxWidth, constraints.maxHeight));
          }),
        ),
      );
    });
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({Key key, this.upgrade, this.side}) : super(key: key);
  final Upgrade upgrade;
  final double side;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showUpgradeDetails(context, upgrade);
      },
      child: Container(
        width: side,
        height: side,
        padding: EdgeInsets.all(4),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.white12),
          child: Column(children: <Widget>[
            Expanded(
                child: SvgPicture.asset(
                    'assets/img/buildings/${upgrade.name.toLowerCase()}.svg')),
            FittedBox(
              child: Text(
                upgrade.name,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

_showUpgradeDetails(BuildContext context, Upgrade upgrade) {
  final size = MediaQuery.of(context).size;
  final Orientation orientation = (size.width / size.height > 1.7)
      ? Orientation.landscape
      : Orientation.portrait;
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
              height: orientation == Orientation.landscape
                  ? size.height * 0.8
                  : size.height * 0.5,
              width: orientation == Orientation.landscape
                  ? size.width * 0.5
                  : size.width * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black54),
              child: Column(
                children: [
                  Text(
                    upgrade.name,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: SvgPicture.asset(
                          'assets/img/buildings/${upgrade.name.toLowerCase()}.svg')),
                  Text(
                    upgrade.description,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      _UpgradeDialogStatsBox(
                          header: upgrade.effect, value: upgrade.effectValue),
                      _UpgradeDialogStatsBox(
                          header: 'Cost', value: upgrade.cost.toString()),
                    ],
                  ),
                  SizedBox(
                    width: 360,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Buy'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

class _UpgradeDialogStatsBox extends StatelessWidget {
  const _UpgradeDialogStatsBox({Key key, this.header, this.value})
      : super(key: key);

  final String header;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(4)),
        child: LayoutBuilder(builder: (_, constraints) {
          return constraints.maxHeight - 28.sp > 4
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(header),
                    Center(
                      child: Text(value,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold)),
                );
        }),
      ),
    );
  }
}
