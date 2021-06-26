import 'package:space_empires/models/defense_ships_model.dart';
import 'package:space_empires/models/planet_model.dart';
import 'package:space_empires/services/planet/planet.dart';
import 'package:space_empires/models/upgrade_model.dart';

mixin Planets {
  late List<Planet> _planets;

  set planetsInit(List<Planet> planets) {
    _planets = planets;
  }

  List<Planet> get planets {
    return _planets;
  }

  int get planetsIncome {
    int income = 0;
    for (final planet in _planets) {
      income += planet.income;
    }
    return income;
  }

  void addPlanet(Planet planet) {
    _planets.add(planet);
  }

  void removePlanet(PlanetName name) {
    _planets.removeWhere((element) => element.name == name);
  }

  void planetAddShip(
      {required DefenseShipType type,
      required PlanetName name,
      required int quantity}) {
    _planets
        .firstWhere((planet) => planet.name == name)
        .defenseAddShip(type, quantity);
  }

  void planetRemoveShip(
      {required DefenseShipType type,
      required PlanetName name,
      required int quantity}) {
    _planets
        .firstWhere((planet) => planet.name == name)
        .defenseRemoveShip(type, quantity);
  }

  void planetAddUpgrade({required UpgradeType type, required PlanetName name}) {
    _planets.firstWhere((planet) => planet.name == name).upgradeAdd(type);
  }

  bool planetUpgradeAvailable(
      {required UpgradeType type, required PlanetName name}) {
    return !_planets
        .firstWhere((planet) => planet.name == name)
        .upgradePresent(type);
  }

  bool isPlanetMy({required PlanetName name}) {
    bool result = false;
    for (final planet in _planets) {
      if (planet.name == name) {
        result = true;
        break;
      }
    }
    return result;
  }

  int planetsGPIBonus() {
    int result = 0;
    for (final planet in _planets) {
      result += planet.planetGPIBonus;
    }
    return result;
  }

  Map<String, int> planetStats({required PlanetName name}) {
    return _planets.firstWhere((planet) => planet.name == name).stats;
  }

  int planetShipCount(
      {required DefenseShipType type, required PlanetName name}) {
    return _planets
        .firstWhere((planet) => planet.name == name)
        .defenseShipCount(type);
  }
}
