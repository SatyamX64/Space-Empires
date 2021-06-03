import '../attack_ships_model.dart';

mixin Military {
  Map<AttackShipType, int> _ownedShips = {};

  Map<AttackShipType, int> get allShips {
    return _ownedShips;
  }

  int get militaryExpenditure {
    int expense = 0;
    for (AttackShipType type in List.from(_ownedShips.keys)) {
      expense += _ownedShips[type] * kAttackShipsData[type].maintainance;
    }
    return expense;
  }

  int get militaryMoraleImpact {
    int impact = 0;
    for (AttackShipType type in List.from(_ownedShips.keys)) {
      impact += _ownedShips[type] * kAttackShipsData[type].morale;
    }
    return impact;
  }

  int militaryShipCount(AttackShipType type) {
    return _ownedShips[type];
  }

  void militaryInit() {
    _ownedShips[AttackShipType.Astro] = 3;
    _ownedShips[AttackShipType.Magnum] = 3;
    _ownedShips[AttackShipType.Rover] = 5;
  }

  void militaryAddShip(AttackShipType type, int quantity) {
    _ownedShips[type] += quantity;
  }

  void militaryRemoveShip(AttackShipType type, int quantity) {
    if (_ownedShips[type] > quantity) {
      _ownedShips[type] -= quantity;
    } else {
      _ownedShips[type] = 0;
    }
  }
}
