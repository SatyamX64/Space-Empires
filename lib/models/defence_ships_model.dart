import 'package:flutter/material.dart';

enum DefenceShipType {
  Artillery,
  Battleship,
  Rover,
}

class DefenceShip {
  DefenceShipType type;
  String description;
  int cost;
  int morale;

  DefenceShip(
      {@required this.cost,
      @required this.description,
      @required this.type,
      @required this.morale});
}

List<DefenceShip> defenceShips = [
  DefenceShip(
      cost: 3000,
      description: 'Boom Boom everything',
      type: DefenceShipType.Artillery,
      morale: 4),
  DefenceShip(
      cost: 2500,
      description: 'The workhorse',
      type: DefenceShipType.Battleship,
      morale: 3),
  DefenceShip(
      cost: 1000,
      description: 'It aint much..but its good',
      type: DefenceShipType.Rover,
      morale: 1),
];
