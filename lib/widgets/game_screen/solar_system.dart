import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/screens/planet_screen.dart';
import 'package:some_game/widgets/static_stars_bg.dart';

class SolarSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final Orientation orientation = MediaQuery.of(context).orientation;

      final double cellSize = size.width / 4;

      final spaceLeft = orientation == Orientation.landscape
          ? ((size.height - (2 * cellSize)))
          : ((size.height - (6 * cellSize)));
      final double mainAxisPadding =
          orientation == Orientation.landscape ? spaceLeft / 2 : spaceLeft / 6;

      // crossAxisPadding = (crossAxisCount*(spaceLeft/mainAxisCount))/2
      final double crossAxisPadding = spaceLeft < 0
          ? (orientation == Orientation.landscape
              ? (spaceLeft).abs()
              : (4 * (spaceLeft).abs() / 6) / 2)
          : 0;

      final List<StaggeredTile> _portraitTilesLayout = [
        StaggeredTile.count(3, 1),
        StaggeredTile.count(1, 2),
        StaggeredTile.count(1, 2),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 1),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 2),
        StaggeredTile.count(2, 1),
      ];

      final List<StaggeredTile> _landscapeTilesLayout = [
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
      ];
      return Container(
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            StaticStarsBackGround(),
            StaggeredGridView.count(
              crossAxisCount: 4,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: mainAxisPadding > 0 ? mainAxisPadding : 0,
              padding: EdgeInsets.symmetric(horizontal: crossAxisPadding),
              children: List.generate(8, (index) => _PlanetCard(index)),
              staggeredTiles: orientation == Orientation.landscape
                  ? _landscapeTilesLayout
                  : _portraitTilesLayout,
            ),
          ],
        ),
      );
    });
  }
}

class _PlanetCard extends StatelessWidget {
  final int index;
  _PlanetCard(this.index);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
