import 'package:flutter/material.dart';

enum AttackShipType {
  Magnum,
  Astro,
  Rover,
}

class AttackShip {
  final AttackShipType type;
  final String description;
  final int cost;
  final int damage;
  final int health;
  final int point;
  final int morale;
  final int maintainance;

  const AttackShip(
      {@required this.cost,
      @required this.point,
      @required this.description,
      @required this.type,
      @required this.health,
      @required this.damage,
      @required this.morale,
      @required this.maintainance});
}

const Map<AttackShipType, AttackShip> kAttackShipsData = const {
  AttackShipType.Rover: const AttackShip(
    cost: 800,
    description: 'Small angry boi',
    type: AttackShipType.Rover,
    point: 2,
    morale: 1,
    damage: 80,
    health: 300,
    maintainance: 5,
  ),
  AttackShipType.Magnum: const AttackShip(
    cost: 3000,
    description: 'This is death incarnate',
    type: AttackShipType.Magnum,
    point: 3,
    morale: 5,
    damage: 300,
    health: 1000,
    maintainance: 25,
  ),
  AttackShipType.Astro: const AttackShip(
    cost: 2500,
    description: 'Can take a beating',
    point: 1,
    type: AttackShipType.Astro,
    morale: 4,
    damage: 120,
    health: 2200,
    maintainance: 15,
  ),
};
