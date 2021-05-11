import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:some_game/models/attack_ships_model.dart';

showMilitaryMenu(BuildContext context) {
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
          child: DefaultTabController(
            length: 3,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: size.height * 0.6,
                width: size.width * 0.8,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.8),
                    Theme.of(context).primaryColor.withOpacity(0.8)
                  ]),
                ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TabBar(
                          unselectedLabelColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: CircleTabIndicator(
                              color: Colors.white, radius: 3),
                          tabs: List.generate(
                              attackShips.length,
                              (index) => Tab(
                                    text: describeEnum(attackShips[index].type),
                                  ))),
                    ),
                    // Expanded(
                    //     child: Column(
                    //   children: [
                    //     Expanded(
                    //         child: Container(
                    //       margin: EdgeInsets.all(4),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(4),
                    //         color: Colors.black12,
                    //       ),
                    //       child: Column(
                    //         children: [
                    //           Expanded(
                    //               child: Container(
                    //             alignment: Alignment.center,
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 InkWell(
                    //                   customBorder: const CircleBorder(),
                    //                   onTap: () {},
                    //                   child: Container(
                    //                     padding: const EdgeInsets.all(6.0),
                    //                     decoration: const BoxDecoration(
                    //                       color: Colors.black26,
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child:
                    //                         const Icon(Icons.add, size: 24.0),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   alignment: Alignment.center,
                    //                   margin: EdgeInsets.symmetric(
                    //                       horizontal: 4, vertical: 8),
                    //                   width: 32,
                    //                   child: Text(
                    //                     '23',
                    //                     style: TextStyle(
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ),
                    //                 InkWell(
                    //                   customBorder: const CircleBorder(),
                    //                   onTap: () {},
                    //                   child: Container(
                    //                     alignment: Alignment.center,
                    //                     padding: const EdgeInsets.all(6.0),
                    //                     decoration: const BoxDecoration(
                    //                       color: Colors.black26,
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: const Icon(Icons.remove,
                    //                         size: 24.0),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           )),
                    //         ],
                    //       ),
                    //     )),
                    //   ],
                    // )),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

class AttackShipInfo extends StatelessWidget {
  const AttackShipInfo({Key key, this.attackShip}) : super(key: key);

  final AttackShip attackShip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ),
        Expanded(
          child: Row(children: [
            _TransactionButton(
              text: 'Buy',
              onTap: () {},
            ),
            _TransactionButton(
              text: 'Sell',
              onTap: () {},
            ),
          ]),
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
                .headline3
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ));
  }
}

class _ShipStats extends StatelessWidget {
  const _ShipStats({
    Key key,
    this.attackShip,
  }) : super(key: key);

  final AttackShip attackShip;

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
        flex: 2,
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black12,
          ),
          padding: EdgeInsets.all(16),
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
                        child: SvgPicture.asset(
                            'assets/img/ships/attack/${describeEnum(attackShip.type).toLowerCase()}.svg'),
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
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
