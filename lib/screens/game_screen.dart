import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/screens/planet_screen.dart';
import 'package:some_game/widgets/control_deck.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:some_game/widgets/control_deck/attack.dart';
import 'package:some_game/widgets/gradient_fab.dart';

class GameScreen extends StatelessWidget {
  static const route = '/game-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _NextTurnFAB(onTap: () {}),
      bottomNavigationBar: ControlDeck(
        onPressed: (index) {
          showAttackMenu(context);
        },
        backgroundColor: Color(0xFF0A2D4B),
        notchedShape: CircularNotchedRectangle(),
        showText: false,
        iconSize: 48,
        height: 72,
        items: [
          ControlDeckItem(text: 'Attack'),
          ControlDeckItem(text: 'Military'),
          ControlDeckItem(text: 'Stats'),
          ControlDeckItem(text: 'Rivals'),
        ],
      ),
      body: Column(
        children: [
          _StatsBar(),
          _SolarSystem(),
        ],
      ),
    );
  }
}

class _NextTurnFAB extends StatelessWidget {
  const _NextTurnFAB({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientFAB(
            onTap: onTap,
            toolTip: 'Next Turn',
            image: 'assets/img/control_deck/next.svg'),
      ),
    );
  }
}


class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: Colors.black,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            Theme.of(context).primaryColor.withOpacity(0.4),
            Colors.black
          ], stops: [
            0.0,
            0.7,
            1.0
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '10,000 💲 |  ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Days : 1/999',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SolarSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 36 - 72,
      width: size.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/img/stars_bg.png')),
      ),
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        children: List.generate(8, (index) => _PlanetCard(index)),
        mainAxisSpacing: 16,
        staggeredTiles: [
          StaggeredTile.count(3, 1),
          StaggeredTile.count(1, 2),
          StaggeredTile.count(1, 2),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 1),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 1),
        ],
      ),
    );
  }
}

class _PlanetCard extends StatelessWidget {
  final int index;
  _PlanetCard(this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, PlanetScreen.route,
              arguments: planetsList[index]);
        },
        child: Column(
          children: [
            Flexible(
                child: Hero(
                    tag: planetsList[index].name,
                    child: Image.asset(
                        'assets/img/planets/${describeEnum(planetsList[index].name).toLowerCase()}.png'))),
            Text(describeEnum(planetsList[index].name)),
          ],
        ),
      ),
    );
  }
}
