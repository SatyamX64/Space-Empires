import 'package:space_empires/models/attack_ships_model.dart';

mixin Military {
  // ignore: prefer_final_fields
  Map<AttackShipType, int> _ships = {};

  Map<AttackShipType, int> get ships {
    return _ships;
  }

  int get militaryExpenditure {
    int expense = 0;
    for (final type in _ships.keys.toList()) {
      expense += _ships[type]! * kAttackShipsData[type]!.maintainance;
    }
    return expense;
  }

  int get militaryMoraleImpact {
    int impact = 0;
    for (final type in _ships.keys.toList()) {
      impact += _ships[type]! * kAttackShipsData[type]!.morale;
    }
    return impact;
  }

  int militaryShipCount(AttackShipType type) {
    return _ships[type]!;
  }

  void militaryInit() {
    _ships[AttackShipType.romeo] = 5;
    _ships[AttackShipType.magnum] = 3;
    _ships[AttackShipType.optimus] = 3;
    assert(_ships.length == AttackShipType.values.length);
  }

  void militaryAddShip(AttackShipType type, int quantity) {
    _ships[type] = _ships[type]! + quantity;
  }

  void militaryRemoveShip(AttackShipType type, int quantity) {
    if (_ships[type]! > quantity) {
      _ships[type] = _ships[type]! - quantity;
    } else {
      _ships[type] = 0;
    }
  }
}
