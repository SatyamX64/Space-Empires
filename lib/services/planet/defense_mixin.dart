import 'package:space_empires/models/defense_ships_model.dart';

mixin Defense {
  // ignore: prefer_final_fields
  Map<DefenseShipType, int> _ships = {};

  void defenseInit() {
    _ships[DefenseShipType.rover] = 10;
    _ships[DefenseShipType.artillery] = 7;
    _ships[DefenseShipType.battleship] = 5;
  }

  int get defenseExpenditure {
    int expense = 0;
    for (final type in List.from(_ships.keys)) {
      expense += _ships[type] * kDefenseShipsData[type].maintainance;
    }
    return expense;
  }

  Map<DefenseShipType, int> get ships {
    return _ships;
  }

  int defenseShipCount(DefenseShipType type) {
    return _ships[type];
  }

  void defenseAddShip(DefenseShipType type, int value) {
    _ships[type] += value;
  }

  void defenseRemoveShip(DefenseShipType type, int value) {
    if (_ships[type] > value) {
      _ships[type] -= value;
    } else {
      _ships[type] = 0;
    }
  }
}
