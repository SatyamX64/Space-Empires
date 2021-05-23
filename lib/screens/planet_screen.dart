import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:some_game/models/game_data.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/widgets/planet_screen/defense.dart';
import 'package:some_game/widgets/planet_screen/stats.dart';
import 'package:some_game/widgets/planet_screen/upgrades.dart';
import 'package:some_game/widgets/static_stars_bg.dart';

class PlanetScreen extends StatelessWidget {
  static const route = '/planet-screen';

  PlanetScreen(this._planetName);

  final PlanetName _planetName;

  Widget _wrapWithProvider(Widget child) {
    return Provider<PlanetName>.value(
      value: _planetName,
      builder: (_, __) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Map<String, Widget> _displayMode = {
      'Stats': _wrapWithProvider(PlanetStats()),
      'Upgrades': _wrapWithProvider(PlanetUpgrades()),
      'Defense': _wrapWithProvider(PlanetDefense()),
    };

    Widget _planetImage() {
      return Expanded(
        child: Hero(
            tag: describeEnum(_planetName),
            child: Image.asset(
                'assets/img/planets/${describeEnum(_planetName).toLowerCase()}.png')),
      );
    }

    Widget _tabBar() {
      return TabBar(
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink[700], opacityPrimaryColor(0.5)]),
          borderRadius: BorderRadius.circular(50),
        ),
        tabs: List.generate(
          _displayMode.keys.length,
          (index) => Tab(
            text: List.from(_displayMode.keys)[index],
          ),
        ),
      );
    }

    Widget _tabView() {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: TabBarView(
            children: List.generate(_displayMode.values.length,
                (index) => List.from(_displayMode.values)[index]),
          ),
        ),
      );
    }

    Widget _description() {
      return Expanded(
          child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child: Text(
          Provider.of<GameData>(context, listen: false)
              .getPlanetDescription(_planetName),
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(describeEnum(_planetName)),
          actions: [
            Consumer<Player>(
              builder: (_, player, __) {
                return Center(
                  child: Text(
                    '${player.money} 💲 ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ],
        ),
        body: Provider.of<Player>(context).isPlanetMy(name: _planetName)
            ? Stack(
                // If Planet is owned by Player
                children: [
                  StaticStarsBackGround(),
                  orientation == Orientation.landscape
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _planetImage(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: _tabBar(),
                                  ),
                                ],
                              ),
                            ),
                            _tabView(),
                          ],
                        )
                      : Column(
                          children: [
                            _planetImage(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: _tabBar(),
                            ),
                            _tabView(),
                          ],
                        ),
                ],
              )
            : Stack(
                // If Planet is not owned by Player
                children: [
                  StaticStarsBackGround(),
                  orientation == Orientation.landscape
                      ? Row(
                          children: [
                            _planetImage(),
                            _description(),
                          ],
                        )
                      : Column(
                          children: [
                            _planetImage(),
                            _description(),
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}
