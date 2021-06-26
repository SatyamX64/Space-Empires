import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:space_empires/services/player/player.dart';

import '../circle_tab_indicator.dart';
import '/models/attack_ships_model.dart';
import '/utility/utility.dart';
import '/widgets/gradient_dialog.dart';

Future<void> showMilitaryMenu(BuildContext context) {
  final Player _player = Provider.of<Player?>(context, listen: false)!;
  return showGradientDialog(
      context: context,
      padding: 8,
      child: DefaultTabController(
        length: _player.ships.length,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: List.generate(
                  _player.ships.length,
                  (index) => AttackShipInfo(
                    attackShip:
                        kAttackShipsData[_player.ships.keys.toList()[index]]!,
                  ),
                ),
              ),
            ),
            TabBar(
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: CircleTabIndicator(color: Colors.white, radius: 3),
                tabs: List.generate(
                    _player.ships.length,
                    (index) => Tab(
                          text:
                              describeEnum(_player.ships.keys.toList()[index]).inCaps,
                        ))),
          ],
        ),
      ));
}

class AttackShipInfo extends StatelessWidget {
  const AttackShipInfo({Key? key, required this.attackShip}) : super(key: key);

  final AttackShip attackShip;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Player player = Provider.of<Player?>(context, listen: false)!;
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
      children: orientation == Orientation.landscape
          ? [
              Text(
                describeEnum(attackShip.type).inCaps,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
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
                describeEnum(attackShip.type).inCaps,
                  style: Theme.of(context)
                    .textTheme
                    .headline5!
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
  const _TransactionButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  final String text;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints.expand(),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(4)),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
    ));
  }
}

class _ShipStats extends StatelessWidget {
  const _ShipStats({
    Key? key,
    required this.attackShip,
    required this.flex,
  }) : super(key: key);

  final AttackShip attackShip;
  final int flex;

  Widget _statsText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          height: double.maxFinite,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black12,
          ),
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
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
                Expanded(
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
              ],
            ),
          ),
        ));
  }
}

class _ShipOverview extends StatelessWidget {
  const _ShipOverview({Key? key, required this.attackShip}) : super(key: key);

  final AttackShip attackShip;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.all(4),
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
                    margin: const EdgeInsets.all(4),
                    child: Image.asset(
                        'assets/img/ships/attack/${describeEnum(attackShip.type)}.png'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Consumer<Player?>(
                        builder: (_, player, __) {
                          return _MilitaryDialogStatsBox(
                            header: 'You have',
                            value: player!
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
                        style: Theme.of(context).textTheme.headline6!.copyWith(
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
  const _MilitaryDialogStatsBox(
      {Key? key, required this.header, required this.value})
      : super(key: key);

  final String header;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return constraints.maxHeight - 28.sp > 0
                ? Column(
                    children: [
                      Text(
                        header,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white54),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            value,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
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
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
