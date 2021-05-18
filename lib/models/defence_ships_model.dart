import 'package:flutter/material.dart';

enum DefenseShipType {
  Artillery,
  Battleship,
  Rover,
}

class DefenceShip {
  final DefenseShipType type;
  final String description;
  final int cost;
  final int maintainance;
  final int damage;
  final int health;

  const DefenceShip(
      {@required this.cost,
      @required this.description,
      @required this.type,
      @required this.maintainance,
      @required this.damage,
      @required this.health});
}

Map<DefenseShipType, DefenceShip> kDefenseShipsData = {
  DefenseShipType.Artillery: const DefenceShip(
      cost: 3000,
      description: 'Boom Boom everything',
      type: DefenseShipType.Artillery,
      maintainance: 40,
      health: 1200,
      damage: 200),
  DefenseShipType.Battleship: const DefenceShip(
      cost: 2500,
      description: 'The workhorse',
      type: DefenseShipType.Battleship,
      maintainance: 30,
      health: 2500,
      damage: 120),
  DefenseShipType.Rover: const DefenceShip(
      cost: 1000,
      description: 'It aint much..but its good',
      type: DefenseShipType.Rover,
      maintainance: 10,
      health: 500,
      damage: 100),
};
