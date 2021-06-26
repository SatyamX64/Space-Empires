import 'dart:math';

import 'package:flutter/material.dart';

import '/models/defense_ships_model.dart';
import '/models/planet_model.dart';
import 'defense_mixin.dart';
import 'upgrade_mixin.dart';

class Planet with ChangeNotifier, Defense, PlanetUpgrade {
  late final PlanetName name;
  late final String description;
  late final int revenue;
  late bool inWar; // True If Planet was attacked on Current Day
  late int morale;

  Planet(this.name) {
    description = kPlanetsDescriptionData[name]!;
    init();
  }

  void init() {
    statsInit();
    upgradesInit();
    defenseInit();
    inWar = false;
  }

  void statsInit() {
    revenue = 2500;
    morale = 300;
  }

  int get income {
    return ((revenue * planetRevenueBoost) *
                (1 + (morale * planetMoraleBoost) / 1000))
            .round() -
        defenseExpenditure;
  }

  int get militaryMight {
    int militaryMight = 0;
    for (final shipType in ships.keys.toList()) {
      militaryMight =
          kDefenseShipsData[shipType]!.point * defenseShipCount(shipType);
    }
    return (militaryMight * (1 + planetDefensePoints * 0.05)).floor();
  }

  int get defensePoints {
    return planetDefensePoints;
  }

  Map<String, int> get stats {
    return {
      'morale': morale,
      'income': income,
      'defense': defensePoints,
    };
  }

  int effectFromDamageOutput(List<int> damageOutputs) {
    // Calculates the likeablility factor for this Position
    // The higher, the more chances AI will use this formation
    // Result is based on what position lets us destroy most Ships
    // Each ship is assigned some points, and overall score for each formation is calculated based on that

    int damageFactor = 0;
    // ignore: prefer_final_locals
    Map<DefenseShipType, int> shipDestroyed = {};
    for (int i = 0; i < damageOutputs.length; i++) {
      final shipsLost =
          damageOutputs[i] ~/ kDefenseShipsData[ships.keys.toList()[i]]!.health;
      shipDestroyed[ships.keys.toList()[i]] =
          min(defenseShipCount(ships.keys.toList()[i]), shipsLost);
    }
    for (final ship in ships.keys.toList()) {
      damageFactor += shipDestroyed[ship]! * kDefenseShipsData[ship]!.point;
    }
    return damageFactor;
  }

  List<int> damageOutputForFormation(List<int> formation) {
    // Calculates how much damage will be done at pos[i] if ships attack with this formation
    // ignore: prefer_final_locals
    List<int> damageOutput = List.generate(formation.length,
        (index) => 0); // What Damage will ship at pos[i] reciveve
    for (int i = 0; i < formation.length; i++) {
      final shipCount = defenseShipCount(ships.keys.toList()[i]);
      final shipAttackPower = kDefenseShipsData[ships.keys.toList()[i]]!.damage;
      damageOutput[formation[i]] +=
          (shipCount * shipAttackPower * (1 + (planetDefensePoints * 0.05)))
              .toInt();
      // Each Defense Level Increases the Damage Output by 5%
    }
    return damageOutput;
  }

  int defendAgainstDamageOutput(List<int> damageOutputs) {
    // Takes the list of how much damage each ship at pos 'i' will take
    // and gives that damage to all the ships at pos[i]
    for (int i = 0; i < damageOutputs.length; i++) {
      final shipsLost =
          damageOutputs[i] ~/ kDefenseShipsData[ships.keys.toList()[i]]!.health;
      defenseRemoveShip(ships.keys.toList()[i], shipsLost);
    }
    notifyListeners();
    int shipsLeft = 0;
    for (final ship in ships.keys.toList()) {
      shipsLeft += defenseShipCount(ship);
    }
    return shipsLeft;
  }
}
