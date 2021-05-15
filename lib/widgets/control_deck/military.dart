import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:some_game/widgets/gradient_dialog.dart';

import '../circle_tab_indicator.dart';

showMilitaryMenu(BuildContext context) {
  return showGradientDialog(
      context: context,
      padding: 8,
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TabBarView(
                    children: List.generate(
              attackShips.length,
              (index) => AttackShipInfo(
                attackShip: attackShips[index],
              ),
            ))),
            TabBar(
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: CircleTabIndicator(color: Colors.white, radius: 3),
                tabs: List.generate(
                    attackShips.length,
                    (index) => Tab(
                          text: describeEnum(attackShips[index].type),
                        ))),
          ],
        ),
      ));
}

class AttackShipInfo extends StatelessWidget {
  const AttackShipInfo({Key key, this.attackShip}) : super(key: key);

  final AttackShip attackShip;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: orientation == Orientation.landscape
          ? [
              Text(
                describeEnum(attackShip.type),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              _ShipOverview(
                attackShip: attackShip,
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _ShipStats(
                      attackShip: attackShip,
                      flex: 4,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _TransactionButton(
                            text: 'Buy',
                            onTap: () {},
                          ),
                          _TransactionButton(
                            text: 'Sell',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : [
              Text(
                describeEnum(attackShip.type),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              _ShipOverview(
                attackShip: attackShip,
              ),
              _ShipStats(
                attackShip: attackShip,
                flex: 2,
              ),
              Expanded(
                child: Row(
                  children: [
                    _TransactionButton(
                      text: 'Buy',
                      onTap: () {},
                    ),
                    _TransactionButton(
                      text: 'Sell',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
    );
  }
}

class _TransactionButton extends StatelessWidget {
  const _TransactionButton({Key key, this.text, this.onTap}) : super(key: key);

  final String text;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: this.onTap,
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(4)),
        child: Text(this.text,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold)),
      ),
    ));
  }
}

class _ShipStats extends StatelessWidget {
  const _ShipStats({
    Key key,
    this.attackShip,
    this.flex,
  }) : super(key: key);

  final AttackShip attackShip;
  final int flex;

  _statsText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black12,
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statsText('Damage'),
                      _statsText('Health'),
                      _statsText('Morale'),
                      _statsText('Cost'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statsText(': ${attackShip.damage}'),
                      _statsText(': ${attackShip.health}'),
                      _statsText(': ${attackShip.morale}'),
                      _statsText(': ${attackShip.cost}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class _ShipOverview extends StatelessWidget {
  _ShipOverview({Key key, @required this.attackShip}) : super(key: key);

  final AttackShip attackShip;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black12,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        margin: EdgeInsets.all(4),
                        child: Image.asset(
                            'assets/img/ships/attack/${describeEnum(attackShip.type).toLowerCase()}.png'),
                        // SvgPicture.asset(
                        //     'assets/img/ships/attack/${describeEnum(attackShip.type).toLowerCase()}.svg'),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          _MilitaryDialogStatsBox(
                            header: 'You have',
                            value: '45',
                          ),
                          _MilitaryDialogStatsBox(
                            header: 'Cost',
                            value: attackShip.cost.toString(),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(attackShip.description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Italianno',
                              fontSize: 24,
                            )))),
              ],
            )));
  }
}

class _MilitaryDialogStatsBox extends StatelessWidget {
  const _MilitaryDialogStatsBox({Key key, this.header, this.value})
      : super(key: key);

  final String header;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            Text(
              header,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Center(
                child: Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
