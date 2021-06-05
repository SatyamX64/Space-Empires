import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/models/player/player.dart';
import '/utility/interaction.dart';
import '../models/planet_model.dart';
import '../models/rivals_model.dart';
import '../models/ruler_model.dart';

const int kGameDays = 365;

class Game extends ChangeNotifier {
  int days;
  List<Player> players;
  List<String> galacticNews;
  Map<Ruler, Map<Ruler, RivalRelation>> galacticRelations;
  Ruler selectedRuler;
  List<PlanetName> planetsInWar;
  List<Ruler> rulersThatAttacked;

  Game() {
    initGame();
  }

  void initGame() {
    initPlayers();
    initGalacticRelations();
    initGalacticNews();
    initAttackStatus();
    days = kGameDays;
  }

  void initAttackStatus() {
    planetsInWar = [];
    rulersThatAttacked = [];
  }

  bool get lostGame => !(currentPlayer.planets.length > 0 && days > 0);

  bool get wonGame => (currentPlayer.planets.length == planets.length);

  bool canAttackThisTurn(Ruler ruler) {
    return !rulersThatAttacked.contains(ruler);
  }

  void resetAllData() {
    selectedRuler = null;
    initGame();
  }

  void initPlayers() {
    players = [];
    players.add(Player(planets: <Planet>[
      Planet(PlanetName.Miavis),
      Planet(PlanetName.Drukunides)
    ], ruler: Ruler.Morbo));
    players.add(Player(
        planets: <Planet>[Planet(PlanetName.Arth), Planet(PlanetName.Musk)],
        ruler: Ruler.Zapp));
    players.add(Player(planets: <Planet>[
      Planet(PlanetName.Jupinot),
      Planet(PlanetName.Ocorix)
    ], ruler: Ruler.NdNd));
    players.add(Player(
        planets: <Planet>[Planet(PlanetName.Eno), Planet(PlanetName.Hounus)],
        ruler: Ruler.Nudar));
  }

  void initGalacticRelations() {
    galacticRelations = {};
    for (Ruler _firstRuler in Ruler.values) {
      galacticRelations[_firstRuler] = {};
    }
    for (Ruler _firstRuler in Ruler.values) {
      for (Ruler _secondRuler in Ruler.values) {
        if (_firstRuler != _secondRuler) {
          galacticRelations[_firstRuler][_secondRuler] = RivalRelation.Peace;
        }
      }
    }
  }

  void initGalacticNews() {
    galacticNews = [];
  }

  void clearNews() {
    galacticNews = [];
  }

  void initCurrentPlayer(Ruler value) {
    selectedRuler = value;
    notifyListeners();
  }

  String descriptionForRuler(Ruler ruler) {
    return kRulerDescriptionData[ruler];
  }

  Player get currentPlayer {
    return players.firstWhere((player) => player.ruler == selectedRuler);
  }

  List<Player> get computerPlayers {
    return List<Player>.from(
        players.where((player) => player.ruler != currentPlayer.ruler));
  }

  List<Planet> get planets {
    List<Planet> _planets = [];
    players.forEach((player) {
      _planets.addAll(player.planets);
    });
    return _planets;
  }

  Color colorForRuler(Ruler ruler) {
    switch (ruler) {
      case Ruler.Morbo:
        return Colors.green[900];
      case Ruler.Nudar:
        return Colors.pink;
      case Ruler.NdNd:
        return Colors.deepPurple;
      case Ruler.Zapp:
        return Colors.orange[600];
    }
    return Colors.white; // Highly Unlikely, Indicates a error somewhere
  }

  Player playerFromRuler(Ruler ruler) {
    return players.firstWhere((player) => player.ruler == ruler);
  }

  Player playerForPlanet(PlanetName planetName) {
    return players.firstWhere((player) => player.isPlanetMy(name: planetName));
  }

  void removeDeadPlayers() {
    // A Player is dead if he has no planets left
    players.removeWhere((player) {
      if (player.planets.length == 0) {
        galacticNews.add(
            '${describeEnum(player.ruler)} died in the last battle. His galatic empire is over ');
        return true;
      } else
        return false;
    });
  }

  void changeOwnerOfPlanet({Ruler newRuler, PlanetName name}) {
    galacticNews.add(
        '${describeEnum(newRuler)} took over the Planet ${describeEnum(name)}');
    playerForPlanet(name).removePlanet(name);
    playerFromRuler(newRuler).addPlanet(Planet(name));
    notifyListeners();
  }

  nextTurn() {
    days--;
    players.forEach((player) {
      // Each Player gets their income from all their planets
      player.nextTurn();
    });
    computerPlayers.forEach((player) {
      // Each computer player buys Military/Defense/Upgrades/Stats from available Money
      player.autoTurn();
      print(' ${player.money} + ${player.galacticPowerIndex}');
    });

    // Each Computer Player might change Relation with other races depending upon their GPI difference
    autoUpdateRelation();
    computerAttacksComputer();
    notifyListeners();
    return computerAttacksCurrentPlayer();
  }

  autoUpdateRelation() {
    // Update Relation among different Rulers based on GPI difference
    // Computer won't trade among themselves, neither will they ever propose Trade
    // Only the current Player can begin trading with computer
    // Although Computer can stop trading and revert back to peace

    // Generally a Player who is in superior position will likely want war
    // If player is weaker, there is relatively less chances that he will change relation
    for (Player computerPlayer in computerPlayers) {
      for (Player rivalPlayer in players) {
        if (rivalPlayer.ruler != computerPlayer.ruler) {
          int diff = computerPlayer.galacticPowerIndex -
              rivalPlayer.galacticPowerIndex;
          RivalRelation relation =
              relationBetweenRulers(computerPlayer.ruler, rivalPlayer.ruler);
          if (diff > godlyDifference) {
            // Player A is in very superior Position
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.8)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                return;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.8)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;

              case RivalRelation.War:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
            }
          } else if (diff > goodDifference) {
            // Player A is doing a lot better
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.6)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                return;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.6)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
              case RivalRelation.War:
                if (chanceSucceeds(0.3)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
            }
          } else if (diff > almostEquals) {
            // Both Players are almost at equal Footing
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.3)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                return;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.3)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
              case RivalRelation.War:
                if (chanceSucceeds(0.4)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
            }
          } else {
            // Player A is not in lead
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                return;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
              case RivalRelation.War:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                return;
            }
          }
        }
      }
    }
  }

  calculateChanceForAutoAttack({Player A, Player B}) {
    int diff = A.galacticPowerIndex - B.galacticPowerIndex;
    if (diff > godlyDifference) {
      return 0.9;
    } else if (diff > goodDifference) {
      return 0.7;
    } else if (diff > almostEquals) {
      return 0.3;
    } else
      return 0.1;
  }

  void computerAttacksComputer() {
    for (Player attacker in computerPlayers) {
      for (Player defender in computerPlayers) {
        if (attacker.ruler != defender.ruler &&
            relationBetweenRulers(attacker.ruler, defender.ruler) ==
                RivalRelation.War &&
            canAttackThisTurn(attacker.ruler)) {
          double chance =
              calculateChanceForAutoAttack(A: attacker, B: defender);
          if (chanceSucceeds(chance)) {
            List<Planet> defenderPlanets = List.from(
                enemyPlanetsFor(attacker.ruler)
                    .where((planet) => defender.planets.contains(planet)));
            int selectedPlanetIndex = Random().nextInt(defenderPlanets.length);
            if (planetsInWar
                .contains(defender.planets[selectedPlanetIndex].name)) {
              // i.e the defender has already had a attack on that planet in this turn
              // So defense is likely very low
              // So We can't allow other to attack before next turn
              continue;
            }
            // diff in military might suggests, how well the attacking military and defenders fare off against each other
            int diffMilitaryMight = attacker.militaryMight -
                defender.planets[selectedPlanetIndex].militaryMight;
            PlanetName targettedPlanet =
                defenderPlanets[selectedPlanetIndex].name;
            planetsInWar.add(targettedPlanet);
            rulersThatAttacked.add(attacker.ruler);
            if (diffMilitaryMight > 10) {
              attacker.destroyMilitary(0.1);
              changeOwnerOfPlanet(
                  newRuler: attacker.ruler, name: targettedPlanet);
              break;
            } else {
              attacker.destroyMilitary(0.3);
            }
          }
        }
      }
    }
  }

  Map computerAttacksCurrentPlayer() {
    for (Player attacker in computerPlayers) {
      Player defender = currentPlayer;
      if (relationBetweenRulers(attacker.ruler, defender.ruler) ==
              RivalRelation.War &&
          canAttackThisTurn(attacker.ruler)) {
        double chance = calculateChanceForAutoAttack(A: attacker, B: defender);
        if (chanceSucceeds(chance)) {
          List<Planet> defenderPlanets = defender.planets;
          int selectedPlanetIndex = Random().nextInt(defenderPlanets.length);
          return {
            'ruler': attacker.ruler,
            'planet': defender.planets[selectedPlanetIndex]
          };
        }
      }
    }
  }

  List<Planet> enemyPlanetsFor(Ruler ruler) {
    List<Planet> enemyPlanets = [];
    players.forEach((player) {
      if (ruler != player.ruler) {
        if (relationBetweenRulers(ruler, player.ruler) == RivalRelation.War) {
          enemyPlanets.addAll(player.planets);
        }
      }
    });
    return enemyPlanets;
  }

  String descriptionForPlanet(PlanetName name) {
    return planets.firstWhere((planet) => planet.name == name).description;
  }

  RivalRelation relationBetweenRulers(Ruler A, Ruler B) {
    return galacticRelations[A][B];
  }

  void updateRelation(Ruler A, Ruler B, RivalRelation relation) {
    galacticRelations[A][B] = relation;
    galacticRelations[B][A] = relation;
    galacticNews.add(
        '${describeEnum(A)} started ${describeEnum(relation).toLowerCase()} with ${describeEnum(B)}');
  }

  // Rival can perform only one Action per turn
  // So you can't ask for war if started trading/peace etc
  String interactWithRival({RivalInteractions action, Ruler A, Ruler B}) {
    RivalRelation _initialRelation = relationBetweenRulers(A, B);
    double chance = calculateChance(
        relation: _initialRelation,
        interactions: action,
        diffGPI: playerFromRuler(A).galacticPowerIndex -
            playerFromRuler(B).galacticPowerIndex);

    if (chanceSucceeds(chance)) {
      Map map =
          yesEffectOfAction(relation: _initialRelation, interactions: action);
      if (_initialRelation != map['relation']) {
        updateRelation(A, B, map['relation']);
      }
      if (action == RivalInteractions.Help) {
        playerFromRuler(A).money += 5000;
      }
      notifyListeners();
      return map['response'];
    } else {
      Map map =
          noEffectOfAction(relation: _initialRelation, interactions: action);
      if (_initialRelation != map['relation']) {
        updateRelation(A, B, map['relation']);
      }
      notifyListeners();
      return map['response'];
    }
  }

  List<RivalInteractions> possibleActions(RivalRelation relation) {
    List<RivalInteractions> _list = [];
    switch (relation) {
      case RivalRelation.War:
        _list.add(RivalInteractions.Peace);
        _list
            .add(RivalInteractions.ExtortForPeace); // Will take money for Peace
        break;
      case RivalRelation.Trade:
        _list.add(RivalInteractions.CancelTrade);
        _list.add(RivalInteractions.Help); // Ask for financial Help
        break;
      case RivalRelation.Peace:
        _list.add(RivalInteractions.Trade);
        _list.add(RivalInteractions.War);
        break;
    }
    return _list;
  }

  bool chanceSucceeds(double chance) {
    return Random().nextInt(100) < (chance * 100).round();
  }

  String getRivalsOpinion(Ruler ruler) {
    // Gives result based on relative GPI
    return 'The Aliens choose to ignore us\nHave better things at hand';
  }
}
