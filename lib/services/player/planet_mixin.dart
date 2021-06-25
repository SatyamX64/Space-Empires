import 'package:space_empires/models/defense_ships_model.dart';
import 'package:space_empires/models/planet_model.dart';
import 'package:space_empires/services/planet/planet.dart';
import 'package:space_empires/models/upgrade_model.dart';

mixin Planets {
  List<Planet> _planets;

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

  void planetAddShip({DefenseShipType type, PlanetName name, int quantity}) {
    _planets
        .firstWhere((planet) => planet.name == name)
        .defenseAddShip(type, quantity);
  }

  void planetRemoveShip({DefenseShipType type, PlanetName name, int quantity}) {
    _planets
        .firstWhere((planet) => planet.name == name)
        .defenseRemoveShip(type, quantity);
  }

  void planetAddUpgrade({UpgradeType type, PlanetName name}) {
    _planets.firstWhere((planet) => planet.name == name).upgradeAdd(type);
  }

  bool planetUpgradeAvailable({UpgradeType type, PlanetName name}) {
    return !_planets
        .firstWhere((planet) => planet.name == name)
        .upgradePresent(type);
  }

  bool isPlanetMy({PlanetName name}) {
    bool result = false;
    for (final planet in _planets) {
      if (planet.name == name) {
        result = true;
        break;
      }
    }
    return result;
  }

  int planetsRespecc() {
    int result = 0;
    for (final planet in _planets) {
      result += planet.planetRespecc;
    }
    return result;
  }

  Map<String, int> planetStats({PlanetName name}) {
    return _planets.firstWhere((planet) => planet.name == name).stats;
  }

  int planetShipCount({DefenseShipType type, PlanetName name}) {
    return _planets
        .firstWhere((planet) => planet.name == name)
        .defenseShipCount(type);
  }
}
