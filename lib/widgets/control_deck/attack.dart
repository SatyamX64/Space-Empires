import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:some_game/models/planet_model.dart';
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
        Expanded(
            flex: 4,
            child: LayoutBuilder(
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
        Expanded(
          flex: 3,
          child: _MyForce(),
        ),
        Expanded(
          child: Container(),
        ),
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
    return Container(
      child: Row(
        children: [
          _MyForceCard(
            name: 'astro',
            quantity: 45,
          ),
          _MyForceCard(
            name: 'magnum',
            quantity: 45,
          ),
          _MyForceCard(
            name: 'rover',
            quantity: 45,
          ),
        ],
      ),
    );
  }
}

class _MyForceCard extends StatelessWidget {
  const _MyForceCard({
    Key key,
    this.name,
    this.quantity,
  }) : super(key: key);

  final name;
  final quantity;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF0A2D4B)),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset('assets/img/ships/attack/$name.svg'),
                ),
              ),
            ),
          ),
          Text(quantity.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

class _EnemyPlanets extends StatelessWidget {
  _EnemyPlanets({Key key, this.constraints}) : super(key: key);

  final BoxConstraints constraints;
  final List<Planet> _availablePlanets =
      List.from(planetsList.where((planet) => planet.ruler != Ruler.Zapp));

  _planetCard(String planetName) {
    return Container(
      width: constraints.maxWidth / 3,
      height: constraints.maxHeight / 2,
      padding: EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Image.asset('assets/img/planets/$planetName.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black26,
      ),
      child: Wrap(
        children: List.generate(
            _availablePlanets.length,
            (index) => _planetCard(
                describeEnum(_availablePlanets[index].name).toLowerCase())),
      ),
    );
  }
}
