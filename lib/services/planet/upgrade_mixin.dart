import 'package:space_empires/models/upgrade_model.dart';

mixin PlanetUpgrade {
  Map<UpgradeType, bool> _planetUpgrade = {};

  void upgradesInit() {
    for (UpgradeType upgrade in UpgradeType.values) {
      _planetUpgrade[upgrade] = false;
    }
  }

  Map<UpgradeType, bool> get allUpgrades {
    return _planetUpgrade;
  }

  bool upgradePresent(UpgradeType type) {
    return _planetUpgrade[type];
  }

  void upgradeAdd(UpgradeType type) {
    _planetUpgrade[type] = true;
  }

  int get planetDefenseQuotient {
    int turret = upgradePresent(UpgradeType.Charm) ? 1 : 0;
    int watchTower = upgradePresent(UpgradeType.Illumina) ? 2 : 0;
    return turret + watchTower;
  }

  double get planetMoraleBoost {
    double townCenter = upgradePresent(UpgradeType.Starlink) ? 0.1 : 0;
    double moske = upgradePresent(UpgradeType.Colosseum) ? 0.25 : 0;
    return 1 + moske + townCenter;
  }

  double get planetRevenueBoost {
    double boost = upgradePresent(UpgradeType.Electricity) ? 1.10 : 1;
    return boost;
  }

  int get planetTradeBoost {
    int boost = upgradePresent(UpgradeType.Starlink) ? 1 : 0;
    return boost;
  }
}
