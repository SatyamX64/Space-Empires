enum DefenseShipType {
  artillery,
  battleship,
  rover,
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
      {required this.cost,
      required this.point,
      required this.description,
      required this.type,
      required this.maintainance,
      required this.damage,
      required this.health});
}

const Map<DefenseShipType, DefenseShip> kDefenseShipsData = {
  DefenseShipType.rover: DefenseShip(
      cost: 600,
      description: 'Quick, Cheap , Reliable',
      type: DefenseShipType.rover,
      maintainance: 10,
      point: 4,
      health: 400,
      damage: 350),
  DefenseShipType.artillery: DefenseShip(
      cost: 1600,
      description: 'Clears the Battlefield',
      type: DefenseShipType.artillery,
      point: 10,
      maintainance: 25,
      health: 1000,
      damage: 800),
  DefenseShipType.battleship: DefenseShip(
      cost: 1000,
      description: 'Basically a tank that can fly',
      type: DefenseShipType.battleship,
      maintainance: 20,
      point: 5,
      health: 1600,
      damage: 500),
};
