import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:space_empires/services/player/player.dart';
import '/models/attack_ships_model.dart';
import '/utility/utility.dart';
import '/widgets/gradient_dialog.dart';
import 'package:sizer/sizer.dart';
import '../circle_tab_indicator.dart';

showMilitaryMenu(BuildContext context) {
  final Player _player = Provider.of<Player>(context, listen: false);
  return showGradientDialog(
      context: context,
      padding: 8,
      child: DefaultTabController(
        length: _player.allShips.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TabBarView(
                children: List.generate(
                  _player.allShips.length,
                  (index) => AttackShipInfo(
                    attackShip: kAttackShipsData[
                        List.from(_player.allShips.keys)[index]],
                  ),
                ),
              ),
            ),
            TabBar(
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: CircleTabIndicator(color: Colors.white, radius: 3),
                tabs: List.generate(
                    _player.allShips.length,
                    (index) => Tab(
                          text: describeEnum(
                              List.from(_player.allShips.keys)[index]),
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
    final Player player = Provider.of<Player>(context, listen: false);
    final List<_TransactionButton> transactionButtons = [
      _TransactionButton(
        text: 'Buy',
        onTap: () {
          try {
            player.buyAttackShip(attackShip.type);
          } catch (e) {
            Utility.showToast(e.toString());
          }
        },
      ),
      _TransactionButton(
        text: 'Sell',
        onTap: () {
          try {
            player.sellAttackShip(attackShip.type);
          } catch (e) {
            Utility.showToast(e.toString());
          }
        },
      ),
    ];
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
                        children: transactionButtons,
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
                  children: transactionButtons,
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
          height: double.maxFinite,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black12,
          ),
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
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
                        _statsText('Maintainence'),
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
                        _statsText(': ${attackShip.maintainance}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Consumer<Player>(
                        builder: (_, player, __) {
                          return _MilitaryDialogStatsBox(
                            header: 'You have',
                            value: player
                                .militaryShipCount(attackShip.type)
                                .toString(),
                          );
                        },
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
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Italianno',
                            )))),
          ],
        ),
      ),
    );
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
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return constraints.maxHeight - 28.sp > 0
                ? Column(
                    children: [
                      Text(
                        header,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white54),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            value,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                : FittedBox(
                    child: Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
