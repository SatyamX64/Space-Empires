import 'package:flutter/material.dart';

enum UpgradeType {
  Electricity,
  Charm,
  Illumina,
  Explorer,
  Starlink,
  Colosseum
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

const Map<UpgradeType, Upgrade> kUpgradesData = const {
  UpgradeType.Electricity: const Upgrade(
      type: UpgradeType.Electricity,
      cost: 30000,
      description: 'Brings the Industrial Revolution',
      effect: 'Income',
      effectValue: '+10%'),
  UpgradeType.Charm: const Upgrade(
      type: UpgradeType.Charm,
      cost: 25000,
      description: 'A Bio-Tech Weapon to support your Ships',
      effect: 'Defense',
      effectValue: '+1'),
  UpgradeType.Illumina: const Upgrade(
      type: UpgradeType.Illumina,
      cost: 40000,
      description: 'A Worthy Successor to Charm',
      effect: 'Defense',
      effectValue: '+2'),
  UpgradeType.Explorer: const Upgrade(
      type: UpgradeType.Explorer,
      cost: 25000,
      description: 'Finds new Intergalactic Trade Routes',
      effect: 'Trade',
      effectValue: '+1'),
  UpgradeType.Starlink: const Upgrade(
      type: UpgradeType.Starlink,
      cost: 40000,
      description: 'Connects the Planet By Internet',
      effect: 'Morale',
      effectValue: '+10%'),
  UpgradeType.Colosseum: const Upgrade(
      type: UpgradeType.Colosseum,
      cost: 90000,
      description: 'The Ultimate Proof of a Planet\'s Advancement',
      effect: 'Morale',
      effectValue: '+25%'),
};
