import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/screens/planet_screen.dart';
import 'package:some_game/widgets/static_stars_bg.dart';
import 'package:sizer/sizer.dart';

class SolarSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PlanetName> _planetList = PlanetName.values;
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
              children: List.generate(_planetList.length,
                  (index) => _PlanetCard(_planetList[index])),
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
  final PlanetName planetName;
  _PlanetCard(this.planetName);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PlanetScreen.route, arguments: planetName);
      },
      child: Column(
        children: [
          Flexible(
              child: Hero(
                  tag: describeEnum(planetName),
                  child: Image.asset(
                      'assets/img/planets/${describeEnum(planetName).toLowerCase()}.png'))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<Game>(
                builder: (_, _gameData, ___) {
                  var _ruler = _gameData.playerForPlanet(planetName).ruler;
                  var _color = _gameData.colorForRuler(_ruler);
                  return Container(
                    height: 6.sp,
                    width: 6.sp,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration:
                        BoxDecoration(color: _color, shape: BoxShape.circle),
                  );
                },
              ),
              Flexible(
                  child: Text(
                describeEnum(planetName),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
