import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../services/planet/planet.dart';
import '/models/planet_model.dart';
import '/models/upgrade_model.dart';
import '/services/player/player.dart';
import '/utility/utility.dart';

class PlanetUpgrades extends StatelessWidget {
  const PlanetUpgrades({
    Key? key,
  }) : super(key: key);

  double _getSize(double n, double w, double h) {
    // Finds the biggest square size , such that "n" squares can fit in a w*h rectangle
    double sw, sh;
    final pw = (sqrt(n * w / h)).ceilToDouble();
    if ((pw * h / w).floorToDouble() * pw < n) {
      sw = h / (pw * h / w).ceilToDouble();
    } else {
      sw = w / pw;
    }
    final ph = (sqrt(n * h / w)).ceilToDouble();
    if ((ph * w / h).floorToDouble() * ph < n) {
      sh = w / (w * ph / h).ceilToDouble();
    } else {
      sh = h / ph;
    }
    return max(sw, sh);
  }

  @override
  Widget build(BuildContext context) {
    final Player _player = Provider.of<Player?>(context, listen: false)!;
    final PlanetName _planetName =
        Provider.of<PlanetName>(context, listen: false);
    final Planet _planet =
        _player.planets.firstWhere((planet) => planet.name == _planetName);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        alignment: Alignment.center,
        child: Wrap(
          children: List.generate(_planet.upgrades.length, (index) {
            return _UpgradeCard(
                upgrade: kUpgradesData[_planet.upgrades.keys.toList()[index]]!,
                side: _getSize(_planet.upgrades.length.toDouble(),
                    constraints.maxWidth, constraints.maxHeight));
          }),
        ),
      );
    });
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({Key? key, required this.upgrade, required this.side})
      : super(key: key);
  final Upgrade upgrade;
  final double side;
  @override
  Widget build(BuildContext context) {
    final Player player = Provider.of<Player?>(context, listen: false)!;
    final PlanetName planetName =
        Provider.of<PlanetName>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _showUpgradeDetails(context, upgrade, () {
          try {
            player.buyUpgrade(type: upgrade.type, name: planetName);
          } catch (e) {
            Utility.showToast(e.toString());
          }
        }, player.planetUpgradeAvailable(type: upgrade.type, name: planetName));
      },
      child: Container(
        width: side,
        height: side,
        padding: const EdgeInsets.all(4),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.white12),
          child: Column(children: <Widget>[
            Expanded(
                child: Image.asset(
                    'assets/img/buildings/${describeEnum(upgrade.type)}.png')),
            FittedBox(
              child: Text(
                describeEnum(upgrade.type).inCaps,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Future _showUpgradeDetails(
    BuildContext context, Upgrade upgrade, Function buy, bool available) {
  final size = MediaQuery.of(context).size;
  final Orientation orientation = (size.width / size.height > 1.7)
      ? Orientation.landscape
      : Orientation.portrait;

  return showAnimatedDialog(
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
                  ? size.height * 0.8
                  : size.height * 0.5,
              width: orientation == Orientation.landscape
                  ? size.width * 0.5
                  : size.width * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black54),
              child: Column(
                children: [
                  Text(
                    describeEnum(upgrade.type).inCaps,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: Image.asset(
                          'assets/img/buildings/${describeEnum(upgrade.type)}.png')),
                  Text(
                    upgrade.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      _UpgradeDialogStatsBox(
                          header: upgrade.effect, value: upgrade.effectValue),
                      _UpgradeDialogStatsBox(
                          header: 'Cost', value: upgrade.cost.toString()),
                    ],
                  ),
                  Visibility(
                    visible: available,
                    child: SizedBox(
                      width: 360,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            buy();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Buy'),
                        ),
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
  const _UpgradeDialogStatsBox(
      {Key? key, required this.header, required this.value})
      : super(key: key);

  final String header;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold)),
                );
        }),
      ),
    );
  }
}
