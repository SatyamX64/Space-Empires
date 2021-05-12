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
    return ListView.builder(
        itemCount: defenceShips.length,
        itemBuilder: (_, index) {
          return _DefenceShipCard(defenceShip: defenceShips[index]);
        });
  }
}

class _DefenceShipCard extends StatelessWidget {
  const _DefenceShipCard({
    Key key,
    @required DefenceShip defenceShip,
  })  : _defenceShip = defenceShip,
        super(key: key);

  final DefenceShip _defenceShip;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDefenceDetails(context, _defenceShip);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              height: 60,
              width: 60,
              child: SvgPicture.asset(
                  'assets/img/ships/defence/${describeEnum(_defenceShip.type).toLowerCase()}.svg'),
            ),
            title: Text(
              describeEnum(_defenceShip.type),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            trailing: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                      child: const Icon(Icons.add, size: 24.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    width: 32,
                    child: Text(
                      '23',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      child: const Icon(Icons.remove, size: 24.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_showDefenceDetails(BuildContext context, DefenceShip defenceShip) {
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
                  color: Colors.black54),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    describeEnum(defenceShip.type),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      flex: 4,
                      child: SvgPicture.asset(
                          'assets/img/ships/defence/${describeEnum(defenceShip.type).toLowerCase()}.svg')),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            defenceShip.description,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _DefenceDialogStatsBox(
                                    header: 'Morale',
                                    value: defenceShip.morale.toString()),
                                _DefenceDialogStatsBox(
                                    header: 'Cost',
                                    value: defenceShip.cost.toString()),
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
                          child: Text('Okey'),
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
