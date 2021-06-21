import 'dart:math';
import 'package:flutter/material.dart';
import 'package:space_empires/models/defense_ships_model.dart';
import 'package:space_empires/models/planet_model.dart';
import 'package:space_empires/models/ruler_model.dart';
import 'package:space_empires/services/interaction.dart';
import '/models/attack_ships_model.dart';
import '../planet/planet.dart';
import '/models/upgrade_model.dart';
import 'stats.dart';
import 'military_mixin.dart';
import 'planet_mixin.dart';

enum PlayerType {
  HUMAN,
  COMPUTER,
}

class Player extends ChangeNotifier with Stats, Military, Planets {
  final Ruler ruler;
  final PlayerType playerType;
  int money;
  bool canAttack; // Player Can Only Attack once every Day
  Map<Ruler, bool> _interactionAvailable;

  Player({this.ruler, List<Planet> planets, this.playerType}) {
    money = 10000;
    canAttack = true;
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
    return (militaryMight * (1 + (statValue(StatsType.Military) * 0.025)))
        .toInt();
  }

  int get galacticPowerIndex {
    return statValue(StatsType.Culture) * 5 +
        militaryMight +
        planets.length * 50 +
        planetsRespecc() * 30;
  }

  void nextTurn() {
    canAttack = true;
    initInteraction();
    // Each Attack Ship has some moral effect per turn
    // Can be countered using propoganda
    // Military Effect only negatively effects morale
    // So having extra propoganda won't help whatsoever
    // 1 Propoganda Point can counter 3 Points of Military Morale
    int _militaryEffect =
        min(0, (statValue(StatsType.Propoganda) * 3 - militaryMoraleImpact));

    // Luxury is what basically makes the morale
    // more luxury, more morale
    int _luxuryGains = statValue(StatsType.Luxury) * 6;

    // Culture helps in maintaining the Galactic Power Index
    // More the Culture, Stronger your race will be
    // For Each new planet add around 15
    // Culture doesn't positively affect morale
    // Although if it falls short, it will negatively affect it
    int _culturalEffect =
        min(0, statValue(StatsType.Culture) - min(100, planets.length * 15)) *
            5;
    int _baseMorale = _militaryEffect +
        _luxuryGains +
        _culturalEffect +
        min(250, (galacticPowerIndex * 0.5).ceil());
    planets.forEach((planet) {
      planet.inWar = false;
      planet.morale = _baseMorale;
    });
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
    List<Planet> myPlanets = planets;
    int totalUnits = 100;
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
          moneyAllotted: (moneyAllotted * planetBudgetAllotment[i]/100).floor(),
          planetName: myPlanets[i].name);
    }
  }

  void autoBuyUpgrade(int moneyAllotted) {
    List<Planet> myPlanets = planets;
    int totalUnits = 100;
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
          moneyAllotted: (moneyAllotted * planetBudgetAllotment[i]/100).floor(),
          planetName: myPlanets[i].name);
    }
  }

  void autoUpdateStats() {
    autoIncreaseStats();
    autoDecreaseStats();
  }

  void autoIncreaseStats() {
    while (militaryMoraleImpact > statValue(StatsType.Propoganda) * 3) {
      increaseStat(StatsType.Propoganda);
      if (statValue(StatsType.Propoganda) > 98) {
        break;
      }
    }
    while (planets.length * 15 > statValue(StatsType.Culture)) {
      increaseStat(StatsType.Culture);
      if (statValue(StatsType.Culture) > 98) {
        break;
      }
    }

    if (statValue(StatsType.Luxury) < 95 &&
        statValue(StatsType.Luxury) < planets.length * 20) {
      increaseStat(StatsType.Luxury);
      increaseStat(StatsType.Luxury);
      increaseStat(StatsType.Luxury);
    }
    if (statValue(StatsType.Military) < 95 &&
        statValue(StatsType.Military) < planets.length * 20) {
      increaseStat(StatsType.Military);
      increaseStat(StatsType.Military);
      increaseStat(StatsType.Military);
    }
  }

  void autoDecreaseStats() {
    while (statValue(StatsType.Propoganda) * 3 > militaryMoraleImpact) {
      decreaseStat(StatsType.Propoganda);
      if (statValue(StatsType.Propoganda) < 5) {
        break;
      }
    }
    while (statValue(StatsType.Culture) > planets.length * 15) {
      decreaseStat(StatsType.Culture);
      if (statValue(StatsType.Culture) < 5) {
        break;
      }
    }

    if (statValue(StatsType.Luxury) > planets.length * 20 &&
        statValue(StatsType.Luxury) > 15) {
      decreaseStat(StatsType.Luxury);
      decreaseStat(StatsType.Luxury);
      decreaseStat(StatsType.Luxury);
    }
    if (statValue(StatsType.Military) > 15 &&
        statValue(StatsType.Military) > planets.length * 20) {
      decreaseStat(StatsType.Military);
      decreaseStat(StatsType.Military);
      decreaseStat(StatsType.Military);
    }
  }

  void autoBuyDefenseShipsForPlanet(
      {int moneyAllotted, PlanetName planetName}) {
    List<double> budgets = [0.5, 0.0, 0.5]..shuffle();
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

  int get income {
    return planetsIncome - statsExpenditure - militaryExpenditure;
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

  int effectFromDamageOutput(List<int> damageOutputs) {
    // Calculates the damage that player will recieve due to this damageOutputs
    // This is then used by AI to determine the best position to attack
    // The best position is the one that gives the most damage
    int damageFactor = 0;
    Map<AttackShipType, int> shipDestroyed = {};
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] ~/
          kAttackShipsData[List.from(allShips.keys)[i]].health);
      shipDestroyed[List.from(allShips.keys)[i]] =
          min(militaryShipCount(List.from(allShips.keys)[i]), shipsLost);
    }
    for (var ship in List.from(allShips.keys)) {
      damageFactor += shipDestroyed[ship] * kAttackShipsData[ship].point;
    }
    return damageFactor;
  }

  List<int> damageOutputForFormation(List<int> formation) {
    // Calculates the damage that player will cause using the given formation
    List<int> damageOutput = List.generate(formation.length,
        (index) => 0); // What Damage will enemy ship at pos[i] reciveve
    for (int i = 0; i < formation.length; i++) {
      int shipCount = militaryShipCount(List.from(allShips.keys)[i]);
      int shipAttackPower =
          kAttackShipsData[List.from(allShips.keys)[i]].damage;
      damageOutput[formation[i]] += (shipCount *
              shipAttackPower *
              (1 + (statValue(StatsType.Military) * 0.025)))
          .toInt();
    }
    // print('Player');
    // print(damageOutput);
    // print(position);
    // print('Player End');
    return damageOutput;
  }

  int defendAgainstDamageOutput(List<int> damageOutputs) {
    // Recieves a list of damageOutput caused by Enemy Attack System
    // Each Ships will recieve the damage directed at its position
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] ~/
          kAttackShipsData[List.from(allShips.keys)[i]].health);
      militaryRemoveShip(List.from(allShips.keys)[i], shipsLost);
    }
    notifyListeners();
    int shipsLeft = 0;
    for (var ship in List.from(allShips.keys)) {
      shipsLeft += militaryShipCount(ship);
    }
    return shipsLeft;
  }

  bool interactionChannelStatus(Ruler rival) {
    return _interactionAvailable[rival];
  }

  void closeInteractionChannel(Ruler rival) {
    _interactionAvailable[rival] = false;
    notifyListeners();
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
