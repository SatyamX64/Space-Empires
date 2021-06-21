import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_empires/models/planet_model.dart';
import '/models/defense_ships_model.dart';
import 'defense_mixin.dart';
import 'upgrade_mixin.dart';

class Planet with ChangeNotifier, Defense, PlanetUpgrade {
  PlanetName name;
  String description;
  bool inWar; // True If Planet was attacked on Current Day
  int _morale;
  int _revenue;

  Planet(this.name) {
    this.description = kPlanetsDescriptionData[name];
    init();
  }

  void init() {
    statsInit();
    upgradesInit();
    defenseInit();
    inWar = false;
  }

  void statsInit() {
    _revenue = 2500;
    _morale = 300;
  }

  int get income {
    return ((_revenue * planetRevenueBoost) *
                (1 + (_morale * planetMoraleBoost) / 1000))
            .round() -
        defenseExpenditure;
  }

  int get militaryMight {
    int militaryMight = 0;
    for (DefenseShipType shipType in List.from(allShips.keys)) {
      militaryMight =
          kDefenseShipsData[shipType].point * defenseShipCount(shipType);
    }
    return (militaryMight * (1 + planetDefenseQuotient * 0.05)).floor();
  }

  int get defense {
    return planetDefenseQuotient;
  }

  Map<String, int> get stats {
    return {
      'morale': _morale,
      'income': income,
      'defense': defense,
    };
  }

  set morale(int value) {
    _morale = value;
  }

  set revenue(int value) {
    _revenue = value;
  }

  int effectFromDamageOutput(List<int> damageOutputs) {
    // Calculates the likeablility factor for this Position
    // The higher, the more chances AI will use this formation
    // Result is based on what position lets us destroy most Ships
    // Each ship is assigned some points, and overall score for each formation is calculated based on that

    int damageFactor = 0;
    Map<DefenseShipType, int> shipDestroyed = {};
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] ~/
          kDefenseShipsData[List.from(allShips.keys)[i]].health);
      shipDestroyed[List.from(allShips.keys)[i]] = min(defenseShipCount(List.from(allShips.keys)[i]),shipsLost);
    }
    for (var ship in List.from(allShips.keys)) {
      damageFactor += shipDestroyed[ship] * kDefenseShipsData[ship].point;
    }
    return damageFactor;
  }

  List<int> damageOutputForFormation(List<int> formation) {
    // Calculates how much damage will be done at pos[i] if ships assume this formation
    List<int> damageOutput = List.generate(formation.length,
        (index) => 0); // What Damage will ship at pos[i] reciveve
    for (int i = 0; i < formation.length; i++) {
      int shipCount = defenseShipCount(List.from(allShips.keys)[i]);
      int shipAttackPower =
          kDefenseShipsData[List.from(allShips.keys)[i]].damage;
      damageOutput[formation[i]] +=
          (shipCount * shipAttackPower * (1 + (planetDefenseQuotient * 0.05)))
              .toInt();
      // Each Defense Level Increases the Damage Output by 5%
    }
    // print('Attack PLanet');
    // print(damageOutput);
    // print(positions);
    // print('Planet End');
    return damageOutput;
  }

  int defendAgainstDamageOutput(List<int> damageOutputs) {
    // Takes the list of how much damage each ship at pos 'i' will take
    // and gives that damage to all the ships at pos[i]
    for (int i = 0; i < damageOutputs.length; i++) {
      int shipsLost = (damageOutputs[i] ~/
          kDefenseShipsData[List.from(allShips.keys)[i]].health);
      defenseRemoveShip(List.from(allShips.keys)[i], shipsLost);
    }
    notifyListeners();
    int shipsLeft = 0;
    for (var ship in List.from(allShips.keys)) {
      shipsLeft += defenseShipCount(ship);
    }
    return shipsLeft;
  }
}
