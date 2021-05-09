import 'package:flutter/material.dart';

class Upgrade {
  String name;
  String description;
  String effect;
  String effectValue;
  int cost;

  Upgrade(
      {@required this.name,
      @required this.cost,
      @required this.description,
      @required this.effect,
      @required this.effectValue});
}

List<Upgrade> upgradesList = [
  Upgrade(
      name: 'Town Center',
      cost: 30000,
      description: 'The People\'s Hang out',
      effect: 'Morale',
      effectValue: '+15%'),
  Upgrade(
      name: 'Turret',
      cost: 25000,
      description: 'Blow em to smitherens',
      effect: 'Defence',
      effectValue: '+1'),
  Upgrade(
      name: 'Watch Tower',
      cost: 40000,
      description: 'Fry the Intruders',
      effect: 'Defence',
      effectValue: '+2'),
  Upgrade(
      name: 'Industry',
      cost: 25000,
      description: 'Gotta work for the bread, right ?',
      effect: 'Income',
      effectValue: '+15%'),
  Upgrade(
      name: 'Trade Center',
      cost: 40000,
      description: 'Money flows',
      effect: 'Income',
      effectValue: '+20%'),
  Upgrade(
      name: 'Embassy',
      cost: 70000,
      description: 'Everyone needs Friends',
      effect: 'Trust',
      effectValue: '+1'),
];
