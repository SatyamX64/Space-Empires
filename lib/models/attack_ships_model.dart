import 'package:flutter/material.dart';

enum AttackShipType {
  Magnum,
  Optimus,
  Romeo,
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
  AttackShipType.Romeo: const AttackShip(
    cost: 800,
    description: 'Small but dependable',
    type: AttackShipType.Romeo,
    point: 2,
    morale: 1,
    damage: 80,
    health: 300,
    maintainance: 5,
  ),
  AttackShipType.Magnum: const AttackShip(
    cost: 3000,
    description: 'Attack Power is Second to none',
    type: AttackShipType.Magnum,
    point: 3,
    morale: 5,
    damage: 300,
    health: 1000,
    maintainance: 25,
  ),
  AttackShipType.Optimus: const AttackShip(
    cost: 2500,
    description: 'Will take a lot, to bring this down',
    point: 1,
    type: AttackShipType.Optimus,
    morale: 4,
    damage: 120,
    health: 2200,
    maintainance: 15,
  ),
};
