enum StatsType {
  Propoganda,
  Culture,
  Luxury,
  Military,
}

const int _cost = 5;  // 1 stat point cost each turn

mixin Stats {
  Map<StatsType, int> _stats = {};

  int get statsExpenditure {
    int expense = 0;
    for (StatsType type in List.from(_stats.keys)) {
      expense += _stats[type] * _cost;
    }
    return expense;
  }

  void statsInit() {
    _stats[StatsType.Propoganda] = 40;
    _stats[StatsType.Luxury] = 40;
    _stats[StatsType.Culture] = 40;
    _stats[StatsType.Military] = 40;
  }

  int statValue(StatsType type) {
    return _stats[type];
  }

  void statIncrement(StatsType type) {
    _stats[type]++;
  }

  void statDecrement(StatsType type) {
    if (_stats[type] > 0) {
      _stats[type]--;
    }
  }

  List<StatsType> get statsList {
    return List.from(_stats.keys);
  }
}
