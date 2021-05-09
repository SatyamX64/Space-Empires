import 'package:flutter/material.dart';

enum Ruler {
  NdNd,
  Morbo,
  Nudar,
  Zapp,
}

enum PlanetName {
  Miavis,
  Hounus,
  Drukunides,
  Eno,
  Musk,
  Jupinot,
  Ocorix,
  Arth,
}

class Planet {
  PlanetName name;
  Ruler ruler;
  String description;
  int defence;
  double trade;
  double morale;
  double income;
  Planet(
      {@required this.name,
      @required this.ruler,
      @required this.description,
      this.income: 1000,
      this.defence: 2,
      this.morale: 36.84,
      this.trade: 40.92});
}

List<Planet> planetsList = [
  Planet(
    name: PlanetName.Miavis,
    ruler: Ruler.Morbo,
    description:
        'Part of an failed experiment\nThe Planet goes close to doom every day',
  ),
  Planet(
    name: PlanetName.Hounus,
    ruler: Ruler.Nudar,
    description:
        'The hottest plan there is on the solar system,\nFull of Lava and gold',
  ),
  Planet(
      name: PlanetName.Drukunides,
      ruler: Ruler.Morbo,
      description:
          'Covered in vines and deep forest.\nHome to the most Toxic Snakes in universe'),
  Planet(
      name: PlanetName.Eno,
      ruler: Ruler.Nudar,
      description:
          'Believed to be the home of the Ruler of Seas.\nThe harsh climate has made the inhabitants super durable'),
  Planet(
      name: PlanetName.Musk,
      ruler: Ruler.Zapp,
      description:
          'Humans shifted here recently\nWhen they fucked up in their previous home'),
  Planet(
    name: PlanetName.Jupinot,
    ruler: Ruler.NdNd,
    description:
        'Home to the little lunatic prince. The inhabitants have made no contacts yet with other species',
  ),
  Planet(
      name: PlanetName.Ocorix,
      ruler: Ruler.NdNd,
      description:
          'Dying core of the Star Ocorix. It\'s existence itself is an anomaly'),
  Planet(
      name: PlanetName.Arth,
      ruler: Ruler.Zapp,
      description:
          'Original Home to the humans.\nIs believed to be the perfect place for lifeforms to exist'),
];
