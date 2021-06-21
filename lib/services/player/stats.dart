enum StatsType {
  Propoganda,
  Culture,
  Luxury,
  Military,
}

const Map<StatsType,int> _cost = {
  StatsType.Propoganda : 15,
  StatsType.Luxury : 30,
  StatsType.Culture : 15,
  StatsType.Military : 15,
};  // 1 stat point cost each turn

mixin Stats {
  Map<StatsType, int> _stats = {};

  int get statsExpenditure {
    int expense = 0;
    for (StatsType type in List.from(_stats.keys)) {
      expense += _stats[type] * _cost[type];
    }
    return expense;
  }

  void statsInit() {
    _stats[StatsType.Propoganda] = 30;
    _stats[StatsType.Luxury] = 30;
    _stats[StatsType.Culture] = 30;
    _stats[StatsType.Military] = 30;
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
