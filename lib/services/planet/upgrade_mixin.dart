import 'package:space_empires/models/upgrade_model.dart';

mixin PlanetUpgrade {
  // ignore: prefer_final_fields
  Map<UpgradeType, bool> _upgrades = {};

  void upgradesInit() {
    for (final upgrade in UpgradeType.values) {
      _upgrades[upgrade] = false;
    }
  }

  Map<UpgradeType, bool> get upgrades {
    return _upgrades;
  }

  bool upgradePresent(UpgradeType type) {
    return _upgrades[type]!;
  }

  void upgradeAdd(UpgradeType type) {
    _upgrades[type] = true;
  }

  int get planetDefensePoints {
    final charm = upgradePresent(UpgradeType.charm) ? 1 : 0;
    final illumina = upgradePresent(UpgradeType.illumina) ? 2 : 0;
    return charm + illumina;
  }

  double get planetMoraleBoost {
    final starlink = upgradePresent(UpgradeType.starlink) ? 0.1 : 0.0;
    final explorer = upgradePresent(UpgradeType.explorer) ? 0.15 : 0.0;
    return 1 + starlink + explorer;
  }

  double get planetRevenueBoost {
    final electricity = upgradePresent(UpgradeType.electricity) ? 0.1 : 0.0;
    return 1 + electricity;
  }

  int get planetGPIBonus {
    final boost = upgradePresent(UpgradeType.colosseum) ? 10 : 0;
    return boost;
  }
}
