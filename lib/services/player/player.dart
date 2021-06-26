import 'dart:math';

import 'package:flutter/material.dart';

import 'package:space_empires/models/defense_ships_model.dart';
import 'package:space_empires/models/planet_model.dart';
import 'package:space_empires/models/ruler_model.dart';
import 'package:space_empires/services/interaction.dart';

import '../planet/planet.dart';
import '/models/attack_ships_model.dart';
import '/models/upgrade_model.dart';
import 'military_mixin.dart';
import 'planet_mixin.dart';
import 'stats.dart';

enum PlayerType {
  human,
  computer,
}

class Player extends ChangeNotifier with Stats, Military, Planets {
  late final Ruler ruler;
  late final PlayerType playerType;
  late int money;
  late bool canAttack; // Player Can Only Attack once every Day
  late Map<Ruler, bool> _interactionAvailable;

  Player(
      {required this.ruler,
      required List<Planet> planets,
      required this.playerType}) {
    money = 10000;
    canAttack = true;
    planetsInit = planets;
    statsInit();
    militaryInit();
    initInteraction();
  }

  void initInteraction() {
    _interactionAvailable = {};
    for (final rival in Ruler.values) {
      if (ruler != rival) {
        _interactionAvailable[rival] = true;
      }
    }
  }

  int get militaryMight {
    int militaryMight = 0;
    for (final shipType in ships.keys.toList()) {
      militaryMight =
          kAttackShipsData[shipType]!.point * militaryShipCount(shipType) ;
    }
    return (militaryMight * (1 + (statValue(StatsType.military) * 0.0025)))
        .toInt();
  }

  int get galacticPowerIndex {
    return statValue(StatsType.culture) * 5 +
        militaryMight +
        planets.length * 50 +
        planetsGPIBonus() * 30;
  }

  void nextTurn() {
    canAttack = true;
    initInteraction();
    // Each Attack Ship has some moral effect per turn
    // Can be countered using propoganda
    // Military Effect only negatively effects morale
    // So having extra propoganda won't help whatsoever
    // 1 Propoganda Point can counter 3 Points of Military Morale
    final _militaryEffect =
        min(0, statValue(StatsType.propoganda) * 3 - militaryMoraleImpact);

    // Luxury is what basically makes the morale
    // more luxury, more morale
    final _luxuryGains = statValue(StatsType.luxury) * 6;

    // Culture helps in maintaining the Galactic Power Index
    // More the Culture, Stronger your race will be
    // For Each new planet add around 15
    // Culture doesn't positively affect morale
    // Although if it falls short, it will negatively affect it
    final _culturalEffect = min<int>(0,
            statValue(StatsType.culture) - min<int>(100, planets.length * (Random().nextInt(5) + 10))) *
        5;
    final _baseMorale = _militaryEffect +
        _luxuryGains +
        _culturalEffect +
        min<int>(250, (galacticPowerIndex * 0.5).ceil());
    for (final planet in planets) {
      planet.inWar = false;
      planet.morale = _baseMorale;
    }
    money += income;
    notifyListeners();
  }

  void autoTurn(int avgDiff) {
    // TODO : Here we can use a better strategy for Better Budget Allotment
    // Based on the relations , no of days left, no of planets, power difference etc
    List<double> expendeiture;
    if (avgDiff > godlyDifference) {
      expendeiture = [
        Random().nextDouble() * 0.4,
        Random().nextDouble() * 0.3,
        Random().nextDouble() * 0.3,
      ];
    } else if (avgDiff > goodDifference) {
      expendeiture = [
        Random().nextDouble() * 0.4,
        Random().nextDouble() * 0.2,
        Random().nextDouble() * 0.4,
      ];
    } else if (avgDiff > almostEquals) {
      expendeiture = [
        Random().nextDouble() * 0.2 + 0.1,
        Random().nextDouble() * 0.3 + 0.1,
        Random().nextDouble() * 0.2 + 0.1,
      ];
    } else {
      expendeiture = [
        Random().nextDouble() * 0.3 + 0.2,
        Random().nextDouble() * 0.1 + 0.1,
        Random().nextDouble() * 0.2 + 0.1,
      ];
    }
    autoBuyMilitary((money * expendeiture[0]).floor());
    autoBuyUpgrade((money * expendeiture[1]).floor());
    autoBuyDefense((money * expendeiture[2]).floor());
    autoUpdateStats();
  }

  void autoBuyMilitary(int moneyAllotted) {
    // TODO : Here we can use a better strategy for Better Budget Allotment Military
    final budgets = [0.5, 0.2, 0.3]..shuffle();
    final _attackShips = kAttackShipsData.values.toList();
    for (int i = 0; i < _attackShips.length; i++) {
      final shipsToBuy =
          ((moneyAllotted * budgets[i]) / _attackShips[i].cost).floor();
      for (int j = 0; j < shipsToBuy; j++) {
        buyAttackShip(_attackShips[i].type);
      }
    }
  }

  void autoBuyDefense(int moneyAllotted) {
    final myPlanets = planets;
    int totalUnits = 100;
    // ignore: prefer_final_locals
    List<int> planetBudgetAllotment = [];
    while (planetBudgetAllotment.length != planets.length) {
      if (planets.length - planetBudgetAllotment.length == 1) {
        planetBudgetAllotment.add(totalUnits);
      } else {
        totalUnits = totalUnits ~/ 2;
        planetBudgetAllotment.add(totalUnits);
      }
    }
    myPlanets
        .sort((a, b) => Comparable.compare(a.militaryMight, b.militaryMight));

    for (int i = 0; i < myPlanets.length; i++) {
      autoBuyDefenseShipsForPlanet(
          moneyAllotted:
              (moneyAllotted * planetBudgetAllotment[i] / 100).floor(),
          planetName: myPlanets[i].name);
    }
  }

  void autoBuyUpgrade(int moneyAllotted) {
    final myPlanets = planets;
    int totalUnits = 100;
    // ignore: prefer_final_locals
    List<int> planetBudgetAllotment = [];
    while (planetBudgetAllotment.length != planets.length) {
      if (planets.length - planetBudgetAllotment.length == 1) {
        planetBudgetAllotment.add(totalUnits);
      } else {
        totalUnits = totalUnits ~/ 2;
        planetBudgetAllotment.add(totalUnits);
      }
    }
    myPlanets
        .sort((a, b) => Comparable.compare(a.militaryMight, b.militaryMight));

    for (int i = 0; i < myPlanets.length; i++) {
      autoBuyUpgradeForPlanet(
          moneyAllotted:
              (moneyAllotted * planetBudgetAllotment[i] / 100).floor(),
          planetName: myPlanets[i].name);
    }
  }

  void autoUpdateStats() {
    autoIncreaseStats();
    autoDecreaseStats();
  }

  void autoIncreaseStats() {
    while (militaryMoraleImpact > statValue(StatsType.propoganda) * 3) {
      increaseStat(StatsType.propoganda);
      if (statValue(StatsType.propoganda) > 98) {
        break;
      }
    }
    while (planets.length * 15 > statValue(StatsType.culture)) {
      increaseStat(StatsType.culture);
      if (statValue(StatsType.culture) > 98) {
        break;
      }
    }

    if (statValue(StatsType.luxury) < 95 &&
        statValue(StatsType.luxury) < planets.length * 20) {
      increaseStat(StatsType.luxury);
      increaseStat(StatsType.luxury);
      increaseStat(StatsType.luxury);
    }
    if (statValue(StatsType.military) < 95 &&
        statValue(StatsType.military) < planets.length * 20) {
      increaseStat(StatsType.military);
      increaseStat(StatsType.military);
      increaseStat(StatsType.military);
    }
  }

  void autoDecreaseStats() {
    while (statValue(StatsType.propoganda) * 3 > militaryMoraleImpact) {
      decreaseStat(StatsType.propoganda);
      if (statValue(StatsType.propoganda) < 5) {
        break;
      }
    }
    while (statValue(StatsType.culture) > planets.length * 15) {
      decreaseStat(StatsType.culture);
      if (statValue(StatsType.culture) < 5) {
        break;
      }
    }

    if (statValue(StatsType.luxury) > planets.length * 20 &&
        statValue(StatsType.luxury) > 15) {
      decreaseStat(StatsType.luxury);
      decreaseStat(StatsType.luxury);
      decreaseStat(StatsType.luxury);
    }
    if (statValue(StatsType.military) > 15 &&
        statValue(StatsType.military) > planets.length * 20) {
      decreaseStat(StatsType.military);
      decreaseStat(StatsType.military);
      decreaseStat(StatsType.military);
    }
  }

  void autoBuyDefenseShipsForPlanet(
      {required int moneyAllotted, required PlanetName planetName}) {
    final budgets = [0.5, 0.0, 0.5]..shuffle();
    final _defenseShips = kDefenseShipsData.values.toList();
    for (int i = 0; i < _defenseShips.length; i++) {
      final shipsToBuy =
          ((moneyAllotted * budgets[i]) / _defenseShips[i].cost).floor();
      for (int j = 0; j < shipsToBuy; j++) {
        buyDefenseShip(type: _defenseShips[i].type, name: planetName);
      }
    }
  }

  void autoBuyUpgradeForPlanet(
      {required int moneyAllotted, required PlanetName planetName}) {
    int moneyLeft = moneyAllotted;
    for (final upgradeType in UpgradeType.values) {
      if (planetUpgradeAvailable(type: upgradeType, name: planetName) &&
          moneyLeft > kUpgradesData[upgradeType]!.cost) {
        buyUpgrade(type: upgradeType, name: planetName);
        moneyLeft -= kUpgradesData[upgradeType]!.cost;
      }
    }
  }

  int get income {
    return planetsIncome - statsExpenditure - militaryExpenditure;
  }

  void destroyMilitary(double factor) {
    // Factor is 0.0-1.0
    // Gives the amount of military to destroy
    // Generally trigerred when Player aborts a mission or when AI fights each other
    for (final type in ships.keys) {
      final count = militaryShipCount(type);
      militaryRemoveShip(type, (count * factor).floor());
    }
  }

  int effectFromDamageOutput(List<int> damageOutputs) {
    // Calculates the damage that player will recieve due to this damageOutputs
    // This is then used by AI to determine the best position to attack
    // The best position is the one that gives the most damage
    int damageFactor = 0;
    // ignore: prefer_final_locals
    Map<AttackShipType, int> shipDestroyed = {};
    for (int i = 0; i < damageOutputs.length; i++) {
      final shipsLost =
          damageOutputs[i] ~/ kAttackShipsData[ships.keys.toList()[i]]!.health;
      shipDestroyed[ships.keys.toList()[i]] =
          min(militaryShipCount(ships.keys.toList()[i]), shipsLost);
    }
    for (final ship in ships.keys.toList()) {
      damageFactor += shipDestroyed[ship]! * kAttackShipsData[ship]!.point;
    }
    return damageFactor;
  }

  List<int> damageOutputForFormation(List<int> formation) {
    // Calculates the damage that player will cause using the given formation
    final damageOutput = List.generate(formation.length,
        (index) => 0); // What Damage will enemy ship at pos[i] reciveve
    for (int i = 0; i < formation.length; i++) {
      final shipCount = militaryShipCount(ships.keys.toList()[i]);
      final shipAttackPower = kAttackShipsData[ships.keys.toList()[i]]!.damage;
      damageOutput[formation[i]] += (shipCount *
              shipAttackPower *
              (1 + (statValue(StatsType.military) * 0.025)))
          .toInt();
    }
    return damageOutput;
  }

  int defendAgainstDamageOutput(List<int> damageOutputs) {
    // Recieves a list of damageOutput caused by Enemy Attack System
    // Each Ships will recieve the damage directed at its position
    for (int i = 0; i < damageOutputs.length; i++) {
      final shipsLost =
          damageOutputs[i] ~/ kAttackShipsData[ships.keys.toList()[i]]!.health;
      militaryRemoveShip(ships.keys.toList()[i], shipsLost);
    }
    notifyListeners();
    int shipsLeft = 0;
    for (final ship in ships.keys.toList()) {
      shipsLeft += militaryShipCount(ship);
    }
    return shipsLeft;
  }

  bool interactionChannelStatus(Ruler rival) {
    return _interactionAvailable[rival]!;
  }

  void closeInteractionChannel(Ruler rival) {
    _interactionAvailable[rival] = false;
    notifyListeners();
  }

  void buyAttackShip(AttackShipType type) {
    if (money > kAttackShipsData[type]!.cost) {
      militaryAddShip(type, 1);
      money -= kAttackShipsData[type]!.cost;
      notifyListeners();
    } else {
      throw 'Out of Funds';
    }
  }

  void sellAttackShip(AttackShipType type) {
    if (militaryShipCount(type) > 0) {
      militaryRemoveShip(type, 1);
      money += (kAttackShipsData[type]!.cost * 0.8).round();
      notifyListeners();
    } else {
      throw 'Out of Ships';
    }
  }

  void buyDefenseShip(
      {required DefenseShipType type, required PlanetName name}) {
    if (money > kDefenseShipsData[type]!.cost) {
      planetAddShip(type: type, name: name, quantity: 1);
      money -= kDefenseShipsData[type]!.cost;
      notifyListeners();
    } else {
      throw 'Out of Funds';
    }
  }

  void sellDefenseShip(
      {required DefenseShipType type, required PlanetName name}) {
    final ships = planetShipCount(type: type, name: name);
    if (ships > 0) {
      planetRemoveShip(type: type, name: name, quantity: 1);
      money += (kDefenseShipsData[type]!.cost * 0.8).round();
      notifyListeners();
    } else {
      throw 'Out of Ships';
    }
  }

  void buyUpgrade({required UpgradeType type, required PlanetName name}) {
    if (money > kUpgradesData[type]!.cost) {
      planetAddUpgrade(type: type, name: name);
      money -= kUpgradesData[type]!.cost;
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
