import 'package:flutter/material.dart';

enum DefenseShipType {
  Artillery,
  Battleship,
  Rover,
}

class DefenseShip {
  final DefenseShipType type;
  final String description;
  final int point; // Higher the Points, more the Computer AI will target it
  final int cost;
  final int maintainance;
  final int damage;
  final int health;

  const DefenseShip(
      {@required this.cost,
      @required this.point,
      @required this.description,
      @required this.type,
      @required this.maintainance,
      @required this.damage,
      @required this.health});
}

const Map<DefenseShipType, DefenseShip> kDefenseShipsData = const {
  DefenseShipType.Artillery: const DefenseShip(
      cost: 3500,
      description: 'Clears the Battlefield',
      type: DefenseShipType.Artillery,
      point: 4,
      maintainance: 20,
      health: 600,
      damage: 280),
  DefenseShipType.Battleship: const DefenseShip(
      cost: 2500,
      description: 'Basically a tank that can fly',
      type: DefenseShipType.Battleship,
      maintainance: 15,
      point: 1,
      health: 900,
      damage: 90),
  DefenseShipType.Rover: const DefenseShip(
      cost: 1000,
      description: 'Quick, Cheap , Reliable',
      type: DefenseShipType.Rover,
      maintainance: 10,
      point: 2,
      health: 300,
      damage: 120),
};

/*
Artillery - 6 Romeo, 2 Mag, 4 Optimus 
Battleship - 10 Romeo, 3 Magnum, 6 Optimus
Rover - 3 Romeo,1 Magnum, 2 Optimus
 */