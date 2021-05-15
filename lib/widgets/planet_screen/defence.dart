import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:some_game/models/defence_ships_model.dart';

class PlanetDefence extends StatelessWidget {
  PlanetDefence({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
          itemCount: defenceShips.length,
          itemExtent:
              min(120, max(constraints.maxHeight / defenceShips.length, 90)),
          itemBuilder: (_, index) {
            return _DefenceShipCard(
              defenceShip: defenceShips[index],
              width: constraints.maxWidth,
            );
          });
    });
  }
}

class _DefenceShipCard extends StatelessWidget {
  const _DefenceShipCard(
      {Key key, @required DefenceShip defenceShip, this.width})
      : _defenceShip = defenceShip,
        super(key: key);

  final DefenceShip _defenceShip;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDefenceDetails(context, _defenceShip);
      },
      child: Card(
        color: Colors.blueGrey.withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                  child: Center(
                child: SvgPicture.asset(
                    'assets/img/ships/defence/${describeEnum(_defenceShip.type).toLowerCase()}.svg'),
              )),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    describeEnum(_defenceShip.type),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              Visibility(
                visible: width > 210 ? true : false,
                child: Expanded(
                  flex: 3,
                  child: _BuyMoreShips(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyMoreShips extends StatelessWidget {
  const _BuyMoreShips({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
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
            margin: EdgeInsets.all(4),
            child: Text(
              '243',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
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

_showDefenceDetails(BuildContext context, DefenceShip defenceShip) {
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
                    describeEnum(defenceShip.type),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: SvgPicture.asset(
                          'assets/img/ships/defence/${describeEnum(defenceShip.type).toLowerCase()}.svg')),
                  Text(
                    defenceShip.description,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      _DefenceDialogStatsBox(
                          header: 'Morale',
                          value: defenceShip.morale.toString()),
                      _DefenceDialogStatsBox(
                          header: 'Cost', value: defenceShip.cost.toString()),
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
                        child: Text('Okey'),
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

class _DefenceDialogStatsBox extends StatelessWidget {
  const _DefenceDialogStatsBox({Key key, this.header, this.value})
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(header),
            Center(
              child: Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
