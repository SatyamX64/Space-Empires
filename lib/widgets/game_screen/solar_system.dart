import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/screens/planet_screen.dart';

class SolarSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 36 for StatsBar and 72 for bottomAppBar
    final size = Size(
        MediaQuery.of(context).size.width,
        (MediaQuery.of(context).size.height -
            36 -
            72 -
            MediaQuery.of(context).viewInsets.bottom));
    // Since CrossAxisCount is 4, and horizontalPadding is 2*4
    final cellSize = (size.width - 8) / 4;

    // mainAxis has 6 cells and 4*2 padding
    final spaceLeft = ((size.height - (6 * cellSize) - 8)).floorToDouble();
    final mainAxisPadding = (spaceLeft / 6);

    return Container(
      alignment: Alignment.center,
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/img/stars_bg.png')),
      ),
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: mainAxisPadding > 0 ? mainAxisPadding : 0,
        children: List.generate(8, (index) => _PlanetCard(index)),
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
