import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/widgets/planet/defence.dart';
import 'package:some_game/widgets/planet/stats.dart';
import 'package:some_game/widgets/planet/upgrades.dart';

class PlanetScreen extends StatefulWidget {
  static const route = '/planet-screen';

  PlanetScreen();

  @override
  _PlanetScreenState createState() => _PlanetScreenState();
}

class _PlanetScreenState extends State<PlanetScreen> {
  bool _loadedInitData = false;
  Planet _planet;

  Map<String, Widget> _displayMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs = ModalRoute.of(context).settings.arguments as Planet;
      _planet = routeArgs;
      _loadedInitData = true;
      _displayMode = {
        'Stats': PlanetStats(
          planet: _planet,
        ),
        'Upgrades': PlanetUpgrades(),
        'Defence': PlanetDefence(),
      };
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          centerTitle: true,
          title: Text(describeEnum(_planet.name)),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/stars_bg.png'),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                    tag: _planet.name,
                    child: Image.asset(
                        'assets/img/planets/${describeEnum(_planet.name).toLowerCase()}.png')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TabBar(
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.indigo]),
                        borderRadius: BorderRadius.circular(50),
                        // color: Colors.redAccent
                        ),
                    tabs: List.generate(
                        _displayMode.keys.length,
                        (index) => Tab(
                              text: List.from(_displayMode.keys)[index],
                            ))),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TabBarView(
                    children: List.generate(_displayMode.values.length,
                        (index) => List.from(_displayMode.values)[index]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
