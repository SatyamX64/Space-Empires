enum StatsType {
  propoganda,
  culture,
  luxury,
  military,
}

const Map<StatsType, int> _cost = {
  StatsType.propoganda: 15,
  StatsType.luxury: 30,
  StatsType.culture: 15,
  StatsType.military: 15,
}; // 1 stat point cost each turn

mixin Stats {
  // ignore: prefer_final_fields
  Map<StatsType, int> _stats = {};

  int get statsExpenditure {
    int expense = 0;
    for (final type in List<StatsType>.from(_stats.keys)) {
      expense += _stats[type]! * _cost[type]!;
    }
    return expense;
  }

  void statsInit() {
    _stats[StatsType.propoganda] = 30;
    _stats[StatsType.luxury] = 30;
    _stats[StatsType.culture] = 30;
    _stats[StatsType.military] = 30;
    assert(_cost.length == StatsType.values.length);
    assert(_stats.length == StatsType.values.length);
  }

  int statValue(StatsType type) {
    return _stats[type]!;
  }

  void statIncrement(StatsType type) {
    _stats[type] = _stats[type]! + 1;
  }

  void statDecrement(StatsType type) {
    if (_stats[type]! > 0) {
      _stats[type] = _stats[type]! - 1;
    }
  }

  List<StatsType> get statsList {
    return _stats.keys.toList();
  }
}
