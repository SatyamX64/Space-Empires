import 'package:flutter/material.dart';

enum UpgradeType {
  TownCenter,
  Turret,
  WatchTower,
  Industry,
  TradeCenter,
  Embassy
}

class Upgrade {
  final UpgradeType type;
  final String description;
  final String effect;
  final String effectValue;
  final int cost;

  const Upgrade(
      {@required this.type,
      @required this.cost,
      @required this.description,
      @required this.effect,
      @required this.effectValue});
}

Map<UpgradeType, Upgrade> kUpgradesData = {
  UpgradeType.TownCenter: const Upgrade(
      type: UpgradeType.TownCenter,
      cost: 30000,
      description: 'The People\'s Hang out',
      effect: 'Morale',
      effectValue: '+15%'),
  UpgradeType.Turret: const Upgrade(
      type: UpgradeType.Turret,
      cost: 25000,
      description: 'Blow em to smitherens',
      effect: 'Defence',
      effectValue: '+1'),
  UpgradeType.WatchTower: const Upgrade(
      type: UpgradeType.WatchTower,
      cost: 40000,
      description: 'Fry the Intruders',
      effect: 'Defence',
      effectValue: '+2'),
  UpgradeType.Industry: const Upgrade(
      type: UpgradeType.Industry,
      cost: 25000,
      description: 'Gotta work for the bread, right ?',
      effect: 'Income',
      effectValue: '+15%'),
  UpgradeType.TradeCenter: const Upgrade(
      type: UpgradeType.TradeCenter,
      cost: 40000,
      description: 'Money flows',
      effect: 'Income',
      effectValue: '+20%'),
  UpgradeType.Embassy: const Upgrade(
      type: UpgradeType.Embassy,
      cost: 70000,
      description: 'Everyone needs Friends',
      effect: 'Trust',
      effectValue: '+1'),
};
