import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:some_game/models/upgrade_model.dart';

class PlanetUpgrades extends StatelessWidget {
  PlanetUpgrades({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      children: List.generate(upgradesList.length, (index) {
        return Center(
          child: _UpgradeCard(
            upgrade: upgradesList[index],
          ),
        );
      }),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({Key key, this.upgrade}) : super(key: key);
  final Upgrade upgrade;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showUpgradeDetails(context, upgrade);
      },
      child: Card(
          // color: Theme.of(context).accentColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: SvgPicture.asset(
                            'assets/img/buildings/${upgrade.name.toLowerCase()}.svg')),
                    Text(
                      upgrade.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ]),
            ),
          )),
    );
  }
}

_showUpgradeDetails(BuildContext context, Upgrade upgrade) {
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
              height: size.height * 0.5,
              width: size.width * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black54
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    upgrade.name,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      flex: 4,
                      child: SvgPicture.asset(
                          'assets/img/buildings/${upgrade.name.toLowerCase()}.svg')),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            upgrade.description,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _UpgradeDialogStatsBox(
                                    header: upgrade.effect,
                                    value: upgrade.effectValue),
                                _UpgradeDialogStatsBox(
                                    header: 'Cost',
                                    value: upgrade.cost.toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Buy'),
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
        child: Column(
          children: [
            Text(header),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
