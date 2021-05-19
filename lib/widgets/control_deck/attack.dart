import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/widgets/gradient_dialog.dart';

showAttackMenu(BuildContext context) {
  return showGradientDialog(
    context: context,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Attack',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(child: LayoutBuilder(
          builder: (context, constraints) {
            return _EnemyPlanets(constraints: constraints);
          },
        )),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Your Forces',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _MyForce(),
      ],
    ),
  );
}

class _MyForce extends StatelessWidget {
  const _MyForce({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Player player = Provider.of<Player>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
          children: List.generate(
              kAttackShipsData.length,
              (index) => _MyForceCard(
                    name: describeEnum(List.from(kAttackShipsData.keys)[index])
                        .toLowerCase(),
                    quantity: player.militaryShipCount(
                        List.from(kAttackShipsData.keys)[index]),
                  ))),
    );
  }
}

class _MyForceCard extends StatelessWidget {
  const _MyForceCard({
    Key key,
    this.name,
    this.quantity,
  }) : super(key: key);

  final String name;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              height:
                  min(max(size.width, size.height) / 10, constraints.maxWidth),
              width:
                  min(max(size.width, size.height) / 10, constraints.maxWidth),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: kDeepBlue),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset('assets/img/ships/attack/$name.svg'),
                ),
              ),
            );
          }),
          Text(quantity.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

class _EnemyPlanets extends StatelessWidget {
  _EnemyPlanets({Key key, this.constraints}) : super(key: key);

  final BoxConstraints constraints;

  _planetCard(String planetName) {
    return Container(
      width: constraints.maxWidth * 0.6,
      padding: EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Image.asset('assets/img/planets/$planetName.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameData _gameData = Provider.of<GameData>(context, listen: false);
    final List<Planet> _availablePlanets =
        _gameData.getEnemyPlanets(_gameData.currentPlayer.ruler);
    return _availablePlanets.length <= 0
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.black26),
            child: Text(
              'No Enemy Planets',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          )
        : Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black26,
                ),
                child: CarouselSlider.builder(
                  options: CarouselOptions(),
                  itemCount: _availablePlanets.length,
                  itemBuilder: (BuildContext context, int index, _) =>
                      _planetCard(describeEnum(_availablePlanets[index].name)
                          .toLowerCase()),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_left)),
              Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_right)),
            ],
          );
  }
}
