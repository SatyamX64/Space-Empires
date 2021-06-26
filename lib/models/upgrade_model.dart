enum UpgradeType { electricity, charm, illumina, explorer, starlink, colosseum }

class Upgrade {
  final UpgradeType type;
  final String description;
  final String effect;
  final String effectValue;
  final int cost;

  const Upgrade(
      {required this.type,
      required this.cost,
      required this.description,
      required this.effect,
      required this.effectValue});
}

const Map<UpgradeType, Upgrade> kUpgradesData = {
  UpgradeType.electricity: Upgrade(
      type: UpgradeType.electricity,
      cost: 3500,
      description: 'Brings the Industrial Revolution',
      effect: 'Income',
      effectValue: '+10%'),
  UpgradeType.charm: Upgrade(
      type: UpgradeType.charm,
      cost: 2500,
      description: 'A Bio-Tech Weapon to support your Ships',
      effect: 'Defense',
      effectValue: '+1'),
  UpgradeType.illumina: Upgrade(
      type: UpgradeType.illumina,
      cost: 4000,
      description: 'A Worthy Successor to Charm',
      effect: 'Defense',
      effectValue: '+2'),
  UpgradeType.explorer: Upgrade(
      type: UpgradeType.explorer,
      cost: 5000,
      description: 'Finds new Intergalactic Trade Routes',
      effect: 'Morale',
      effectValue: '+15%'),
  UpgradeType.starlink: Upgrade(
      type: UpgradeType.starlink,
      cost: 4000,
      description: 'Connects the Planet By Internet',
      effect: 'Morale',
      effectValue: '+10%'),
  UpgradeType.colosseum: Upgrade(
      type: UpgradeType.colosseum,
      cost: 7000,
      description: "The Ultimate Proof of a Specie's Advancement",
      effect: 'GPI',
      effectValue: '++'),
};
