import 'dart:math';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:some_game/models/defense_ships_model.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/utility/utility.dart';

class PlanetDefense extends StatelessWidget {
  PlanetDefense({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
          itemCount: kDefenseShipsData.length,
          itemExtent: min(
              120, max(constraints.maxHeight / kDefenseShipsData.length, 90)),
          itemBuilder: (_, index) {
            return _DefenseShipCard(
              defenseShip:
                  List<DefenseShip>.from(kDefenseShipsData.values)[index],
              width: constraints.maxWidth,
            );
          });
    });
  }
}

class _DefenseShipCard extends StatelessWidget {
  const _DefenseShipCard(
      {Key key, @required DefenseShip defenseShip, this.width})
      : _defenseShip = defenseShip,
        super(key: key);

  final DefenseShip _defenseShip;
  final double width;

  @override
  Widget build(BuildContext context) {
    final PlanetName planetName =
        Provider.of<PlanetName>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _showDefenseDetails(context, _defenseShip);
      },
      child: Card(
        color: Colors.blueGrey.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                  child: Center(
                child: SvgPicture.asset(
                    'assets/img/ships/defense/${describeEnum(_defenseShip.type).toLowerCase()}.svg'),
              )),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    describeEnum(_defenseShip.type),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Consumer<Player>(
                builder: (_, player, __) {
                  return Visibility(
                    visible: width > 210 ? true : false,
                    child: Expanded(
                      flex: 3,
                      child: _BuyMoreShips(
                        increment: () {
                          try {
                            player.buyDefenseShip(
                                type: _defenseShip.type, name: planetName);
                          } catch (e) {
                            Utility.showToast(e.toString());
                          }
                        },
                        decrement: () {
                          try {
                            player.sellDefenseShip(
                                type: _defenseShip.type, name: planetName);
                          } catch (e) {
                            Utility.showToast(e.toString());
                          }
                        },
                        value: player.planetShipCount(
                            type: _defenseShip.type, name: planetName),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyMoreShips extends StatelessWidget {
  const _BuyMoreShips({Key key, this.decrement, this.increment, this.value})
      : super(key: key);

  final Function increment;
  final Function decrement;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: increment,
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
              value.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: decrement,
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

_showDefenseDetails(BuildContext context, DefenseShip defenseShip) {
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
                    describeEnum(defenseShip.type),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: SvgPicture.asset(
                          'assets/img/ships/defense/${describeEnum(defenseShip.type).toLowerCase()}.svg')),
                  Text(
                    defenseShip.description,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      _DefenseDialogStatsBox(
                          header: 'Maintainance',
                          value: defenseShip.maintainance.toString()),
                      _DefenseDialogStatsBox(
                          header: 'Cost', value: defenseShip.cost.toString()),
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

class _DefenseDialogStatsBox extends StatelessWidget {
  const _DefenseDialogStatsBox({Key key, this.header, this.value})
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
