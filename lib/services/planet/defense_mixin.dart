import 'package:space_empires/models/defense_ships_model.dart';

mixin Defense {
  // ignore: prefer_final_fields
  Map<DefenseShipType, int> _ships = {};

  void defenseInit() {
    // Make Sure to initialize all the Available Defense Ships in the Game here
    _ships[DefenseShipType.rover] = 10;
    _ships[DefenseShipType.artillery] = 7;
    _ships[DefenseShipType.battleship] = 5;
    assert(_ships.length == DefenseShipType.values.length);
  }

  int get defenseExpenditure {
    int expense = 0;
    for (final type in _ships.keys.toList()) {
      expense += _ships[type]! * kDefenseShipsData[type]!.maintainance;
    }
    return expense;
  }

  Map<DefenseShipType, int> get ships {
    return _ships;
  }

  int defenseShipCount(DefenseShipType type) {
    return _ships[type]!;
  }

  void defenseAddShip(DefenseShipType type, int value) {
    _ships[type] = _ships[type]! + value;
  }

  void defenseRemoveShip(DefenseShipType type, int value) {
    if (_ships[type]! > value) {
      _ships[type] = _ships[type]! - value;
    } else {
      _ships[type] = 0;
    }
  }
}
