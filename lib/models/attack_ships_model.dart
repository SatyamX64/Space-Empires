import 'package:flutter/material.dart';

enum AttackShipType {
  Magnum,
  Astro,
  Rover,
}

class AttackShip {
  AttackShipType type;
  String description;
  int cost;
  int damage;
  int health;
  int morale;

  AttackShip(
      {@required this.cost,
      @required this.description,
      @required this.type,
      @required this.health,
      @required this.damage,
      @required this.morale});
}

List<AttackShip> attackShips = [
  AttackShip(
    cost: 800,
    description: 'Small angry boi',
    type: AttackShipType.Rover,
    morale: 1,
    damage: 80,
    health: 300,
  ),
  AttackShip(
    cost: 3000,
    description: 'This is death incarnate',
    type: AttackShipType.Magnum,
    morale: 4,
    damage: 300,
    health: 1000,
  ),
  AttackShip(
    cost: 2500,
    description: 'Can take a beating',
    type: AttackShipType.Astro,
    morale: 4,
    damage: 120,
    health: 2200,
  ),
];
