import 'package:some_game/models/defence_ships_model.dart';
import 'package:flutter/material.dart';
import 'package:some_game/models/upgrade_model.dart';

enum PlanetName {
  Miavis,
  Hounus,
  Drukunides,
  Eno,
  Musk,
  Jupinot,
  Ocorix,
  Arth,
}

class Planet with Defense, PlanetUpgrade {
  PlanetName name;
  String description;
  int defence;
  int trade;
  int morale;
  int revenue;

  init() {
    initStats();
    upgradesInit();
    defenseInit();
  }

  initStats() {
    revenue = 2000;
    defence = 0;
    morale = 60;
    trade = 20;
  }

  int get income {
    return revenue - defenseExpenditure;
  }

  Map get stats {
    return {
      'morale': morale,
      'income': income,
      'defence': defence,
      'trade': trade,
    };
  }

  Planet.miavis() {
    name = PlanetName.Miavis;
    description =
        'Part of an failed experiment\nThe Planet gets closer to doom every day';
    init();
  }
  Planet.hounus() {
    name = PlanetName.Hounus;
    description =
        'The hottest plan there is on the solar system,\nFull of Lava and gold';
    init();
  }
  Planet.drukunides() {
    name = PlanetName.Drukunides;
    description =
        'Covered in vines and deep forest.\nHome to the most Toxic Snakes in universe';
    init();
  }
  Planet.eno() {
    name = PlanetName.Eno;
    description =
        'Believed to be the home of the Ruler of Seas.\nThe harsh climate has made the inhabitants super durable';
    init();
  }
  Planet.musk() {
    name = PlanetName.Musk;
    description =
        'Humans shifted here recently\nWhen they fucked up in their previous home';
    init();
  }
  Planet.jupinot() {
    name = PlanetName.Jupinot;
    description =
        'Home to the little lunatic prince. The inhabitants have made no contacts yet with other species';
    init();
  }
  Planet.ocorix() {
    name = PlanetName.Ocorix;
    description =
        'Dying core of the Star Ocorix. It\'s existence itself is an anomaly';
    init();
  }
  Planet.arth() {
    name = PlanetName.Arth;
    description =
        'Original Home to the humans.\nIs believed to be the perfect place for lifeforms to exist';
    init();
  }
}

mixin PlanetUpgrade {
  Map<UpgradeType, bool> _planetUpgrade = {};

  void upgradesInit() {
    _planetUpgrade[UpgradeType.TownCenter] = false;
    _planetUpgrade[UpgradeType.Turret] = false;
    _planetUpgrade[UpgradeType.WatchTower] = false;
    _planetUpgrade[UpgradeType.Industry] = false;
    _planetUpgrade[UpgradeType.TradeCenter] = false;
    _planetUpgrade[UpgradeType.Embassy] = false;
  }

  bool upgradePresent(UpgradeType type) {
    return _planetUpgrade[type];
  }

  upgradeBuy(UpgradeType type) {
    _planetUpgrade[type] = true;
  }
}

mixin Defense {
  Map<DefenseShipType, int> _ownedShips = {};

  int get defenseExpenditure {
    int expense = 0;
    for (var type in List.from(_ownedShips.keys)) {
      expense += _ownedShips[type] * kDefenseShipsData[type].maintainance;
    }
    return expense;
  }

  int defenseShipCount(DefenseShipType type) {
    return _ownedShips[type];
  }

  void defenseInit() {
    _ownedShips[DefenseShipType.Battleship] = 3;
    _ownedShips[DefenseShipType.Artillery] = 3;
    _ownedShips[DefenseShipType.Rover] = 5;
  }

  defenseAddShip(DefenseShipType type, int value) {
    _ownedShips[type] += value;
  }

  defenseRemoveShip(DefenseShipType type, int value) {
    if (_ownedShips[type] > value) {
      _ownedShips[type] -= value;
    } else {
      _ownedShips[type] = 0;
    }
  }
}
