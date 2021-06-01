import 'dart:math';
import 'package:flutter/material.dart';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/upgrade_model.dart';
import 'defense_ships_model.dart';
import 'ruler_model.dart';

enum StatsType {
  Propoganda,
  Culture,
  Luxury,
  Military,
}

class Player extends ChangeNotifier with Stats, Military, Planets {
  Ruler ruler;
  int money;
  Map<Ruler, bool> _communicationAvailable = {};

  Player({this.ruler, List<Planet> planets}) {
    money = 10000;
    planetsInit(planets);
    statsInit();
    militaryInit();
    initCommunication();
  }

  void initCommunication() {
    for (Ruler rival in Ruler.values) {
      if (ruler != rival) {
        _communicationAvailable[rival] = true;
      }
    }
  }

  void nextTurn() {
    initCommunication();
    int _baseMorale =
        min(0, (statValue(StatsType.Propoganda) * 5 - militaryMoraleImpact)) +
            (statValue(StatsType.Luxury) * 10) -
            min(0, 100 - statValue(StatsType.Culture));
    planets.forEach((planet) {
      planet.morale = _baseMorale;
      planet.nextTurn();
    });
    money += income;
    notifyListeners();
  }

  void closeCommunicationChannel(Ruler rival) {
    _communicationAvailable[rival] = false;
    notifyListeners();
  }

  bool communicationStatusOpen(Ruler rival) {
    return _communicationAvailable[rival];
  }

  int get income {
    return planetsIncome -
        planets.length * statsExpenditure -
        militaryExpenditure;
  }

  int likeabilityFactor(List<int> damageOutputs) {
    // Calculates the likeablility factor for this Position
    int likeabilityFactor = 0;
    Map<AttackShipType, int> shipDestroyed = {};
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] /
              kAttackShipsData[List.from(allShips.keys)[i]].health)
          .ceil();
      shipDestroyed[List.from(allShips.keys)[i]] = shipsLost;
    }
    for (var ship in List.from(allShips.keys)) {
      likeabilityFactor += shipDestroyed[ship] * kAttackShipsData[ship].point;
    }
    return likeabilityFactor;
  }

  List<int> attack(List<int> positions) {
    List<int> damageOutput = List.generate(positions.length,
        (index) => 0); // What Damage will ship at pos[i] reciveve
    for (int i = 0; i < positions.length; i++) {
      damageOutput[positions[i]] +=
          militaryShipCount(List.from(allShips.keys)[i]) *
              kAttackShipsData[List.from(allShips.keys)[i]].damage;
    }
    return damageOutput;
  }

  int defend(List<int> damageOutputs) {
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] /
              kAttackShipsData[List.from(allShips.keys)[i]].health)
          .ceil();
      militaryRemoveShip(List.from(allShips.keys)[i], shipsLost);
    }
    notifyListeners();
    int shipsLeft = 0;
    for (var ship in List.from(allShips.keys)) {
      shipsLeft += militaryShipCount(ship);
    }
    return shipsLeft;
  }

  void buyAttackShip(AttackShipType type) {
    if (money > kAttackShipsData[type].cost) {
      militaryAddShip(type, 1);
      money -= kAttackShipsData[type].cost;
      notifyListeners();
    } else {
      throw 'Out of Funds';
    }
  }

  void sellAttackShip(AttackShipType type) {
    if (militaryShipCount(type) > 0) {
      militaryRemoveShip(type, 1);
      money += (kAttackShipsData[type].cost * 0.8).round();
      notifyListeners();
    } else {
      throw 'Out of Ships';
    }
  }

  void buyDefenseShip({DefenseShipType type, PlanetName name}) {
    if (money > kDefenseShipsData[type].cost) {
      planetAddShip(type: type, name: name, quantity: 1);
      money -= kDefenseShipsData[type].cost;
      notifyListeners();
    } else {
      throw 'Out of Funds';
    }
  }

  void sellDefenseShip({DefenseShipType type, PlanetName name}) {
    int ships = planetShipCount(type: type, name: name);
    if (ships > 0) {
      planetRemoveShip(type: type, name: name, quantity: 1);
      money += (kDefenseShipsData[type].cost * 0.8).round();
      notifyListeners();
    } else {
      throw 'Out of Ships';
    }
  }

  void buyUpgrade({UpgradeType type, PlanetName name}) {
    if (money > kUpgradesData[type].cost) {
      planetAddUpgrade(type: type, name: name);
      money -= kUpgradesData[type].cost;
      notifyListeners();
    } else {
      throw 'Out of Funds';
    }
  }

  void increaseStat(StatsType type) {
    if (statValue(type) < 100) {
      statIncrement(type);
      notifyListeners();
    } else {
      throw 'Already at Max';
    }
  }

  void decreaseStat(StatsType type) {
    if (statValue(type) > 0) {
      statDecrement(type);
      notifyListeners();
    } else {
      throw 'Already Minimum';
    }
  }
}

mixin Stats {
  Map<StatsType, int> _stats = {};

  int get statsExpenditure {
    int expense = 0;
    for (StatsType type in List.from(_stats.keys)) {
      expense += _stats[type] * 5;
    }
    return expense;
  }

  void statsInit() {
    _stats[StatsType.Propoganda] = 40;
    _stats[StatsType.Luxury] = 40;
    _stats[StatsType.Culture] = 40;
    _stats[StatsType.Military] = 40;
  }

  int statValue(StatsType type) {
    return _stats[type];
  }

  void statIncrement(StatsType type) {
    _stats[type]++;
  }

  void statDecrement(StatsType type) {
    if (_stats[type] > 0) {
      _stats[type]--;
    }
  }

  List<StatsType> get statsList {
    return List.from(_stats.keys);
  }
}

mixin Military {
  Map<AttackShipType, int> _ownedShips = {};

  int get militaryExpenditure {
    int expense = 0;
    for (AttackShipType type in List.from(_ownedShips.keys)) {
      expense += _ownedShips[type] * kAttackShipsData[type].maintainance;
    }
    return expense;
  }

  int get militaryMoraleImpact {
    int impact = 0;
    for (AttackShipType type in List.from(_ownedShips.keys)) {
      impact += _ownedShips[type] * kAttackShipsData[type].morale;
    }
    return impact;
  }

  int militaryShipCount(AttackShipType type) {
    return _ownedShips[type];
  }

  Map<AttackShipType, int> get allShips {
    return _ownedShips;
  }

  void militaryInit() {
    _ownedShips[AttackShipType.Astro] = 3;
    _ownedShips[AttackShipType.Magnum] = 3;
    _ownedShips[AttackShipType.Rover] = 5;
  }

  void militaryAddShip(AttackShipType type, int quantity) {
    _ownedShips[type] += quantity;
  }

  void militaryRemoveShip(AttackShipType type, int quantity) {
    if (_ownedShips[type] > quantity) {
      _ownedShips[type] -= quantity;
    } else {
      _ownedShips[type] = 0;
    }
  }
}

mixin Planets {
  List<Planet> _planets;

  void planetsInit(List<Planet> planets) {
    _planets = planets;
  }

  List<Planet> get planets {
    return _planets;
  }

  int get planetsIncome {
    int income = 0;
    for (Planet planet in _planets) {
      income += planet.income;
    }
    return income;
  }

  void addPlanet(Planet planet) {
    _planets.add(planet);
  }

  void removePlanet(PlanetName name) {
    _planets.removeWhere((element) => element.name == name);
  }

  void planetAddShip({DefenseShipType type, PlanetName name, int quantity}) {
    _planets
        .firstWhere((planet) => planet.name == name)
        .defenseAddShip(type, quantity);
  }

  void planetRemoveShip({DefenseShipType type, PlanetName name, int quantity}) {
    _planets
        .firstWhere((planet) => planet.name == name)
        .defenseRemoveShip(type, quantity);
  }

  void planetAddUpgrade({UpgradeType type, PlanetName name}) {
    _planets.firstWhere((planet) => planet.name == name).upgradeAdd(type);
  }

  bool planetUpgradeAvailable({UpgradeType type, PlanetName name}) {
    return !_planets
        .firstWhere((planet) => planet.name == name)
        .upgradePresent(type);
  }

  bool isPlanetMy({PlanetName name}) {
    bool result = false;
    for (Planet planet in planets) {
      if (planet.name == name) {
        result = true;
        break;
      }
    }
    return result;
  }

  int planetsThatCanTrade() {
    int result = 0;
    for (Planet planet in planets) {
      result += planet.planetTradeBoost;
    }
    return result;
  }

  Map<String, int> planetStats({PlanetName name}) {
    return _planets.firstWhere((planet) => planet.name == name).stats;
  }

  int planetShipCount({DefenseShipType type, PlanetName name}) {
    return _planets
        .firstWhere((planet) => planet.name == name)
        .defenseShipCount(type);
  }
}
