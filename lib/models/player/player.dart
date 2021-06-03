import 'dart:math';
import 'package:flutter/material.dart';
import 'package:some_game/models/attack_ships_model.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/upgrade_model.dart';
import '../defense_ships_model.dart';
import '../ruler_model.dart';
import 'stats.dart';
import 'military_mixin.dart';
import 'planet_mixin.dart';

class Player extends ChangeNotifier with Stats, Military, Planets {
  Ruler ruler;
  int money;
  Map<Ruler, bool> _interactionAvailable;

  Player({this.ruler, List<Planet> planets}) {
    money = 10000;
    planetsInit(planets);
    statsInit();
    militaryInit();
    initInteraction();
  }

  void initInteraction() {
    _interactionAvailable = {};
    for (Ruler rival in Ruler.values) {
      if (ruler != rival) {
        _interactionAvailable[rival] = true;
      }
    }
  }

  int get militaryMight {
    int militaryMight = 0;
    for (AttackShipType shipType in List.from(allShips.keys)) {
      militaryMight =
          kAttackShipsData[shipType].point * militaryShipCount(shipType);
    }
    return militaryMight;
  }

  int get galacticPowerIndex {
    return statValue(StatsType.Military) +
        statValue(StatsType.Culture) +
        militaryMight +
        planets.length * 100;
  }

  void nextTurn() {
    initInteraction();

    // Each Attack Ship has some moral effect per turn
    // Can be countered using propoganda
    // Military Effect only negatively effects morale
    // So having extra propoganda won't help whatsoever
    int _militaryEffect =
        min(0, (statValue(StatsType.Propoganda) * 5 - militaryMoraleImpact));

    // Luxury is what basically makes the morale
    // more luxury, more morale
    int _luxuryGains = statValue(StatsType.Luxury) * 10;

    // Culture helps in maintaining the Galactic Power Index
    // More the Culture, Stronger your race will be
    // Each planets needs around 15
    // Culture doesn't positively affect morale
    // Although if it falls short, it will negatively affect it
    int _culturalEffect =
        min(0, statValue(StatsType.Culture) - min(100, planets.length * 15)) *
            10;
    int _baseMorale = _militaryEffect + _luxuryGains + _culturalEffect;
    planets.forEach((planet) {
      planet.morale = _baseMorale;
    });
    money += income;
    notifyListeners();
  }

  void autoTurn() {
    // Here we can use a better strategy for Better Budget Allotment
    List<double> expendeiture = [0.4, 0.2, 0.3]..shuffle();
    // if (money > 50000) {
    //   expendeiture = [0.1, 0.8, 0.3];
    // } else if (money > 30000) {
    //   expendeiture = [0.1, 0.8, 0.2];
    // } else if (money > 10000) {
    //   expendeiture = [0.2, 0.2, 0.2];
    // } else {
    //   expendeiture = [0.0, 0.0, 0.0];
    // }
    autoBuyMilitary((money * expendeiture[0]).floor());
    autoBuyUpgrade((money * expendeiture[1]).floor());
    autoBuyDefense((money * expendeiture[2]).floor());
    autoUpdateStats();
  }

  void autoBuyMilitary(int moneyAllotted) {
    List<double> budgets = [0.5, 0.2, 0.3]..shuffle();
    List<AttackShip> _attackShips = List.from(kAttackShipsData.values);
    for (int i = 0; i < _attackShips.length; i++) {
      int shipsToBuy =
          ((moneyAllotted * budgets[i]) / _attackShips[i].cost).floor();
      for (int j = 0; j < shipsToBuy; j++) {
        buyAttackShip(_attackShips[i].type);
      }
    }
  }

  void autoBuyDefense(int moneyAllotted) {
    double _planetBudgetAllotment = 1 / planets.length;
    for (Planet planet in planets) {
      autoBuyDefenseShipsForPlanet(
          moneyAllotted: (moneyAllotted * _planetBudgetAllotment).floor(),
          planetName: planet.name);
    }
  }

  void autoBuyUpgrade(int moneyAllotted) {
    double _planetBudgetAllotment = 1 / planets.length;
    for (Planet planet in planets) {
      autoBuyUpgradeForPlanet(
          moneyAllotted: (moneyAllotted * _planetBudgetAllotment).floor(),
          planetName: planet.name);
    }
  }

  void autoUpdateStats() {
    for (StatsType type in StatsType.values) {
      if (statValue(type) < 98) {
        increaseStat(type);
        increaseStat(type);
      }
    }
  }

  void autoBuyDefenseShipsForPlanet(
      {int moneyAllotted, PlanetName planetName}) {
    List<double> budgets = [0.5, 0.2, 0.3]..shuffle();
    List<DefenseShip> _defenseShips = List.from(kDefenseShipsData.values);
    for (int i = 0; i < _defenseShips.length; i++) {
      int shipsToBuy =
          ((moneyAllotted * budgets[i]) / _defenseShips[i].cost).floor();
      for (int j = 0; j < shipsToBuy; j++) {
        buyDefenseShip(type: _defenseShips[i].type, name: planetName);
      }
    }
  }

  void autoBuyUpgradeForPlanet({int moneyAllotted, PlanetName planetName}) {
    int moneyLeft = moneyAllotted;
    for (UpgradeType upgradeType in UpgradeType.values) {
      if (planetUpgradeAvailable(type: upgradeType, name: planetName) &&
          moneyLeft > kUpgradesData[upgradeType].cost) {
        buyUpgrade(type: upgradeType, name: planetName);
        moneyLeft -= kUpgradesData[upgradeType].cost;
      }
    }
  }

  void closeInteractionChannel(Ruler rival) {
    _interactionAvailable[rival] = false;
    notifyListeners();
  }

  bool interactionChannelStatus(Ruler rival) {
    return _interactionAvailable[rival];
  }

  int get income {
    return planetsIncome -
        planets.length * statsExpenditure -
        militaryExpenditure;
  }

  void destroyMilitary(double factor) {
    // Factor is 0.0-1.0
    // Gives the amount of military to destroy
    // Generally trigerred when Player aborts a mission or when AI fights each other
    for (AttackShipType type in (allShips.keys)) {
      int count = militaryShipCount(type);
      militaryRemoveShip(type, (count * factor).floor());
    }
  }

  int damageDoneByFormation(List<int> damageOutputs) {
    // Calculates the damage that player will recieve due to this damageOutputs
    // This is then used by AI to determine the best position to attack
    // The best position is the one that gives the most damage
    int damageFactor = 0;
    Map<AttackShipType, int> shipDestroyed = {};
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] /
              kAttackShipsData[List.from(allShips.keys)[i]].health)
          .ceil();
      shipDestroyed[List.from(allShips.keys)[i]] = shipsLost;
    }
    for (var ship in List.from(allShips.keys)) {
      damageFactor += shipDestroyed[ship] * kAttackShipsData[ship].point;
    }
    return damageFactor;
  }

  List<int> attack(List<int> position) {
    // Calculates the damage that player will cause using the given formation
    List<int> damageOutput = List.generate(position.length,
        (index) => 0); // What Damage will enemy ship at pos[i] reciveve
    for (int i = 0; i < position.length; i++) {
      damageOutput[position[i]] +=
          militaryShipCount(List.from(allShips.keys)[i]) *
              kAttackShipsData[List.from(allShips.keys)[i]].damage;
    }
    return damageOutput;
  }

  int defend(List<int> damageOutputs) {
    // Recieves a list of damageOutput caused by Enemy Attack System
    // Each Ships will recieve the damage directed at its position
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
