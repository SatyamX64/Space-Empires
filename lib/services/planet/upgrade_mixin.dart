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
    double starlink = upgradePresent(UpgradeType.Starlink) ? 0.1 : 0;
    double explorer = upgradePresent(UpgradeType.Explorer) ? 0.15 : 0;
    return 1 + starlink + explorer;
  }

  double get planetRevenueBoost {
    double electricity = upgradePresent(UpgradeType.Electricity) ? 0.1 : 0;
    return 1 + electricity;
  }

  int get planetRespecc {
    int boost = upgradePresent(UpgradeType.Colosseum) ? 10 : 0;
    return boost;
  }
}
