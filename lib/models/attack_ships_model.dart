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
    morale: 3,
    damage: 350,
    health: 300,
    maintainance: 10,
  ),
  AttackShipType.Magnum: const AttackShip(
    cost: 2000,
    description: 'Attack Power is Second to none',
    type: AttackShipType.Magnum,
    point: 8,
    morale: 5,
    damage: 800,
    health: 800,
    maintainance: 25,
  ),
  AttackShipType.Optimus: const AttackShip(
    cost: 1500,
    description: 'Will take a lot, to bring this down',
    point: 4,
    type: AttackShipType.Optimus,
    morale: 4,
    damage: 500,
    health: 1500,
    maintainance: 20,
  ),
};

