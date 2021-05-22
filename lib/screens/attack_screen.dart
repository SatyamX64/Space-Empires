import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:some_game/models/defence_ships_model.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/formation_generator.dart';
import 'package:some_game/widgets/static_stars_bg.dart';
import 'package:sizer/sizer.dart';

class _FormationProvider extends ChangeNotifier {
  final List<List<int>> formations;
  int _selectedFormation;

  _FormationProvider(this.formations) {
    this._selectedFormation = 0;
  }

  get currentFormation {
    return formations[_selectedFormation];
  }

  changeFormation(index) {
    _selectedFormation = index;
    notifyListeners();
  }
}

class AttackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final FormationGenerator formationGenerator = FormationGenerator();
    final _FormationProvider _formationProvider = _FormationProvider(formationGenerator.formations);
    _attackerDefenderImage() {
      return SizedBox(
        height: 60.sp,
        child: Row(
          children: [
            Image.asset(
              'assets/img/avatar/${describeEnum(Ruler.Zapp).toLowerCase()}.png',
            ),
            Spacer(),
            Image.asset(
              'assets/img/avatar/${describeEnum(Ruler.Morbo).toLowerCase()}.png',
            ),
          ],
        ),
      );
    }

    _spaceLights() {
      return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              opacityBlack(0.3),
              kMaroon,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Attack'),
      ),
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _spaceLights(),
          ChangeNotifierProvider.value(
            value: _formationProvider,
            child: orientation == Orientation.landscape
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(child: _Battlefield()),
                            Divider(
                              color: Colors.white38,
                            ),
                            _attackerDefenderImage(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _ControlPanel(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _attackerDefenderImage(),
                      Divider(
                        color: Colors.white38,
                      ),
                      Expanded(child: _Battlefield()),
                      Expanded(
                        child: _ControlPanel(),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  _baseCard({Widget child}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(2.sp),
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
            color: Colors.black45, borderRadius: BorderRadius.circular(4.sp)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.sp),
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  _baseCard(
                    child: Image.asset(
                      'assets/img/planets/${describeEnum(PlanetName.Arth).toLowerCase()}.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  _baseCard(
                      child: Column(
                    children: [
                      Expanded(
                        child: CarouselSlider(
                          items: List.generate(
                            pow(kAttackShipsData.length,
                                kAttackShipsData.length),
                            (index) => Center(
                              child: Text(
                                '${index + 1}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            onPageChanged: (index, _) {
                              Provider.of<_FormationProvider>(context,
                                      listen: false)
                                  .changeFormation(index);
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Formation',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
                ],
              )),
          Expanded(
              flex: 3,
              child: Row(
                children: [
                  _baseCard(
                    child: Text(
                      'Abort',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Italianno"),
                    ),
                  ),
                  _baseCard(
                    child: Text(
                      'Attack',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Italianno"),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _Battlefield extends StatelessWidget {
  const _Battlefield({Key key}) : super(key: key);

  _attackShips(iconSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        kAttackShipsData.length,
        (index) => Padding(
          padding: EdgeInsets.all(16.sp),
          child: SvgPicture.asset(
            'assets/img/ships/attack/${describeEnum(List.from(kAttackShipsData.keys)[index]).toLowerCase()}.svg',
            height: iconSize,
            width: iconSize,
          ),
        ),
      ),
    );
  }

  _defenseShips(iconSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        kDefenseShipsData.length,
        (index) => Padding(
          padding: EdgeInsets.all(16.sp),
          child: SvgPicture.asset(
            'assets/img/ships/defence/${describeEnum(List.from(kDefenseShipsData.keys)[index]).toLowerCase()}.svg',
            height: iconSize,
            width: iconSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final double iconSize =
          (constraints.maxHeight / kAttackShipsData.length - 32.sp);
      return Container(
        child: Row(
          children: [
            _attackShips(iconSize),
            Consumer<_FormationProvider>(
              builder: (_, _target, ___) {
                return Expanded(
                    child: CustomPaint(
                        painter: FormationPainter(
                            formation: _target.currentFormation),
                        child: Container()));
              },
            ),
            _defenseShips(iconSize)
          ],
        ),
      );
    });
  }
}

class FormationPainter extends CustomPainter {
  final List<int> formation;
  FormationPainter({@required this.formation})
      : assert(formation.length == kAttackShipsData.length &&
            formation.length == kDefenseShipsData.length);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.lime
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    List<Offset> startingPoints = [];
    List<Offset> endPoints = [];

    for (int i = 1; i < formation.length * 2; i += 2) {
      startingPoints.add(Offset(0, size.height / (formation.length * 2) * i));
      endPoints
          .add(Offset(size.width, size.height / (formation.length * 2) * i));
    }

    for (int i = 0; i < formation.length; i++) {
      canvas.drawLine(startingPoints[i], endPoints[formation[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
