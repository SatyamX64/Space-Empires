import 'package:space_empires/models/defense_ships_model.dart';

mixin Defense {
  Map<DefenseShipType, int> _ownedShips = {};

  void defenseInit() {
    _ownedShips[DefenseShipType.Rover] = 10;
    _ownedShips[DefenseShipType.Artillery] = 7;
    _ownedShips[DefenseShipType.Battleship] = 5;
  }

  int get defenseExpenditure {
    int expense = 0;
    for (DefenseShipType type in List.from(_ownedShips.keys)) {
      expense += _ownedShips[type] * kDefenseShipsData[type].maintainance;
    }
    return expense;
  }

  Map<DefenseShipType, int> get allShips {
    return _ownedShips;
  }

  int defenseShipCount(DefenseShipType type) {
    return _ownedShips[type];
  }

  void defenseAddShip(DefenseShipType type, int value) {
    _ownedShips[type] += value;
  }

  void defenseRemoveShip(DefenseShipType type, int value) {
    if (_ownedShips[type] > value) {
      _ownedShips[type] -= value;
    } else {
      _ownedShips[type] = 0;
    }
  }
}
