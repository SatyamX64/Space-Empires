import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:space_empires/models/attack_ships_model.dart';
import 'package:space_empires/models/upgrade_model.dart';

import '../models/defense_ships_model.dart';
import '../models/interaction_model.dart';
import '../models/planet_model.dart';
import '../models/ruler_model.dart';
import '/utility/utility.dart';
import 'interaction.dart';
import 'planet/planet.dart';
import 'player/player.dart';

const int kGameDays = 365;

class Game extends ChangeNotifier {
  late int days;
  late List<Player> players;
  late List<String> galacticNews;
  late Map<Ruler, Map<Ruler, Relation>> galacticRelations;

  void initGame(Ruler selectedRuler) {
    initPlayers(selectedRuler);
    initGalacticRelations();
    resetGalacticNews();
    days = kGameDays;
    notifyListeners();
    assert(kDefenseShipsData.length == DefenseShipType.values.length);
    assert(kAttackShipsData.length == AttackShipType.values.length);
    assert(kPlanetsDescriptionData.length == PlanetName.values.length);
    assert(kUpgradesData.length == UpgradeType.values.length);
    assert(kRulerDescriptionData.length == Ruler.values.length);
  }

  bool get lostGame => !(currentPlayer.planets.isNotEmpty && days > 0);

  bool get wonGame => currentPlayer.planets.length == planets.length;

  void initPlayers(Ruler selectedRuler) {
    players = [];
    players.add(
      Player(
          planets: <Planet>[
            Planet(PlanetName.miavis),
            Planet(PlanetName.drukunides)
          ],
          ruler: Ruler.morbo,
          playerType: selectedRuler != Ruler.morbo
              ? PlayerType.computer
              : PlayerType.human),
    );
    players.add(
      Player(
          planets: <Planet>[Planet(PlanetName.arth), Planet(PlanetName.musk)],
          ruler: Ruler.zapp,
          playerType: selectedRuler != Ruler.zapp
              ? PlayerType.computer
              : PlayerType.human),
    );
    players.add(
      Player(
          planets: <Planet>[
            Planet(PlanetName.jupinot),
            Planet(PlanetName.ocorix)
          ],
          ruler: Ruler.ndnd,
          playerType: selectedRuler != Ruler.ndnd
              ? PlayerType.computer
              : PlayerType.human),
    );
    players.add(
      Player(
          planets: <Planet>[Planet(PlanetName.eno), Planet(PlanetName.hounus)],
          ruler: Ruler.nudar,
          playerType: selectedRuler != Ruler.nudar
              ? PlayerType.computer
              : PlayerType.human),
    );
  }

  void initGalacticRelations() {
    galacticRelations = {};
    for (final _firstRuler in Ruler.values) {
      galacticRelations[_firstRuler] = {};
    }
    for (final _firstRuler in Ruler.values) {
      for (final _secondRuler in Ruler.values) {
        if (_firstRuler != _secondRuler) {
          galacticRelations[_firstRuler]![_secondRuler] = Relation.peace;
        }
      }
    }
  }

  void resetGalacticNews() {
    galacticNews = [];
  }

  Player get currentPlayer {
    return players
        .firstWhere((player) => player.playerType == PlayerType.human);
  }

  List<Player> get computerPlayers {
    return List<Player>.from(
        players.where((player) => player.playerType == PlayerType.computer));
  }

  List<Planet> get planets {
    // ignore: prefer_final_locals
    List<Planet> _planets = [];
    for (final player in players) {
      _planets.addAll(player.planets);
    }
    return _planets;
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
      if (player.planets.isEmpty) {
        galacticNews.add(
            '${describeEnum(player.ruler).inCaps} died in the last battle. His galatic empire is over ');
        return true;
      } else {
        return false;
      }
    });
  }

  void changeOwnerOfPlanet(
      {required Ruler newRuler, required PlanetName planetName}) {
    galacticNews.add(
        '${describeEnum(newRuler).inCaps} took over the Planet ${describeEnum(planetName).inCaps}');
    playerForPlanet(planetName).removePlanet(planetName);
    playerFromRuler(newRuler).addPlanet(Planet(planetName));
    notifyListeners();
  }

  Map<String, Object?>? nextTurn() {
    // TODO : The Function that runs on Each Turn, basically the game loop
    days--;
    giveTradeBenefits();
    
    for (final player in players) {
      // Each Player gets their income from all their planets
      // They get their Attack ability back
      // Each Planet goes out of War
      player.nextTurn();
    }
    for (final player in computerPlayers) {
      // Each computer player buys Military/Defense/Upgrades/Stats from available Money
      double rivalsAverageGPI = 0;
      for (final rival in players) {
        if (rival.ruler != player.ruler) {
          rivalsAverageGPI += rival.galacticPowerIndex;
        }
      }
      rivalsAverageGPI /= players.length - 1;
      player.autoTurn((player.galacticPowerIndex - rivalsAverageGPI).toInt());
    }
    // Each Computer Player might change Relation with other races depending upon their GPI difference
    autoUpdateRelation();
    // Computer Attacks other computer Players
    computerAttacksComputer();
    notifyListeners();
    // Computer Attacks current player and info is passed back to game Screen
    
    return computerAttacksCurrentPlayer();
  }

  void giveTradeBenefits() {
    // Trade can be a double edged sword
    // Since both player recieves 5% of each others money
    // So yeah, you'll get more money but so will the other race
    // they will use that money to get strong
    // and you have to confront them eventually to win
    for (final A in players) {
      for (final B in players) {
        if (relationBetweenRulers(A.ruler, B.ruler) == Relation.trade) {
          A.money += (B.money * 0.05).floor();
        }
      }
    }
  }

  void autoUpdateRelation() {
    //TODO : Auto Update Relation Strategy

    // Update Relation among different Rulers based on GPI difference
    // Computer won't trade among themselves, neither will they ever propose Trade
    // Only the current Player can begin trading with computer
    // Although Computer can stop trading and revert back to peace
    // This is because trade needs acceptance from both parties
    // and we can't ask currentPlayer at this point to accept/reject a trade deal

    // Generally a Player who is in superior position will likely want war
    // If player is weaker, there is relatively less chances that he will change relation
    for (final computerPlayer in computerPlayers) {
      for (final rivalPlayer in players) {
        if (rivalPlayer.ruler != computerPlayer.ruler) {
          final diff = computerPlayer.galacticPowerIndex -
              rivalPlayer.galacticPowerIndex;
          final relation =
              relationBetweenRulers(computerPlayer.ruler, rivalPlayer.ruler);
          if (diff > godlyDifference) {
            // Player A is in very superior Position
            switch (relation) {
              case Relation.peace:
                if (chanceSucceeds(0.8)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.war);
                }
                break;
              case Relation.trade:
                if (chanceSucceeds(0.8)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              case Relation.war:
                if (chanceSucceeds(0.1)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              default:
            }
          } else if (diff > goodDifference) {
            // Player A is doing a lot better
            switch (relation) {
              case Relation.peace:
                if (chanceSucceeds(0.6)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.war);
                }
                break;
              case Relation.trade:
                if (chanceSucceeds(0.6)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              case Relation.war:
                if (chanceSucceeds(0.3)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              default:
            }
          } else if (diff > almostEquals) {
            // Both Players are almost at equal Footing, with A being slightly better
            switch (relation) {
              case Relation.peace:
                if (chanceSucceeds(0.3)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.war);
                }
                break;
              case Relation.trade:
                if (chanceSucceeds(0.3)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              case Relation.war:
                if (chanceSucceeds(0.4)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              default:
            }
          } else {
            // Player A is not in lead
            switch (relation) {
              case Relation.peace:
                if (chanceSucceeds(0.1)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.war);
                }
                break;
              case Relation.trade:
                if (chanceSucceeds(0.1)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              case Relation.war:
                if (chanceSucceeds(0.1)) {
                  updateRelation(
                      computerPlayer.ruler, rivalPlayer.ruler, Relation.peace);
                }
                break;
              default:
            }
          }
        }
      }
    }
  }

  double calculateChanceForAutoAttack({required Player A, required Player B}) {
    //TODO : Calculates Chances for Attack from Computer here

    final diff = A.galacticPowerIndex - B.galacticPowerIndex;
    if (diff > godlyDifference) {
      return 0.9;
    } else if (diff > goodDifference) {
      return 0.7;
    } else if (diff > almostEquals) {
      return 0.3;
    } else {
      return 0.05;
    }
  }

  void computerAttacksComputer() {
    for (final attacker in computerPlayers) {
      for (final defender in computerPlayers) {
        if (attacker.ruler != defender.ruler &&
            relationBetweenRulers(attacker.ruler, defender.ruler) ==
                Relation.war &&
            attacker.canAttack) {
          final chance = calculateChanceForAutoAttack(A: attacker, B: defender);
          if (chanceSucceeds(chance)) {
            final defenderPlanets = defender.planets;
            final selectedPlanetIndex =
                Random().nextInt(defenderPlanets.length);
            final defendingPlanet = defenderPlanets[selectedPlanetIndex];
            if (defendingPlanet.inWar) {
              // i.e the planet has already had a attack this day
              // So defense is likely very low
              // So We can't allow other to attack before next turn
              continue;
            }
            // diff in military might suggests, how well the attacking military and defenders fare off against each other
            // Attack will succeed if Military is clearly Superior
            final diffMilitaryMight =
                attacker.militaryMight - defendingPlanet.militaryMight;
            defendingPlanet.inWar = true;
            attacker.canAttack = false;
            if (diffMilitaryMight > godlyDifferenceMilitary) {
              attacker.destroyMilitary(Random().nextDouble() *
                  0.20); // 0-20% Military might be destroyed
              changeOwnerOfPlanet(
                  newRuler: attacker.ruler, planetName: defendingPlanet.name);
              removeDeadPlayers();
              break;
            } else if (diffMilitaryMight > goodDifferenceMilitary) {
              attacker.destroyMilitary(Random().nextDouble() * 0.40);
              changeOwnerOfPlanet(
                  newRuler: attacker.ruler, planetName: defendingPlanet.name);
              removeDeadPlayers();
              break;
            } else if (diffMilitaryMight > almostEqualsMilitary &&
                chanceSucceeds(0.5)) {
              attacker.destroyMilitary(Random().nextDouble() * 0.70);
              changeOwnerOfPlanet(
                  newRuler: attacker.ruler, planetName: defendingPlanet.name);
              removeDeadPlayers();
              break;
            } else {
              attacker.destroyMilitary(Random().nextDouble() * 0.70);
            }
          }
        }
      }
    }
  }

  Map<String, Object>? computerAttacksCurrentPlayer() {
    for (final attacker in computerPlayers) {
      final defender = currentPlayer;
      if (relationBetweenRulers(attacker.ruler, defender.ruler) ==
              Relation.war &&
          attacker.canAttack) {
        final chance = calculateChanceForAutoAttack(A: attacker, B: defender);
        if (chanceSucceeds(chance)) {
          final defenderPlanets = defender.planets;
          final selectedPlanetIndex = Random().nextInt(defenderPlanets.length);
          return {
            'ruler': attacker.ruler,
            'planet': defender.planets[selectedPlanetIndex]
          };
        }
      }
    }
    return null;
  }

  List<Planet> enemyPlanetsFor(Ruler ruler) {
    // ignore: prefer_final_locals
    List<Planet> enemyPlanets = [];
    for (final player in players) {
      if (ruler != player.ruler) {
        if (relationBetweenRulers(ruler, player.ruler) == Relation.war) {
          enemyPlanets.addAll(player.planets);
        }
      }
    }
    return enemyPlanets;
  }

  String descriptionForPlanet(PlanetName name) {
    return planets.firstWhere((planet) => planet.name == name).description;
  }

  Relation? relationBetweenRulers(Ruler A, Ruler B) {
    return galacticRelations[A]![B];
  }

  void updateRelation(Ruler A, Ruler B, Relation relation) {
    galacticRelations[A]![B] = relation;
    galacticRelations[B]![A] = relation;
    galacticNews.add(
        '${describeEnum(A).inCaps} started ${describeEnum(relation).inCaps} with ${describeEnum(B).inCaps}');
  }

  // Each Player can perform only one Action with each player per turn
  // So you can't ask for war if started trading/peace etc
  String interactWithRival(
      {required ChatOptions action, required Ruler A, required Ruler B}) {
    final _initialRelation = relationBetweenRulers(A, B);
    final chance = calculateChance(
        relation: _initialRelation,
        interactions: action,
        diffGPI: playerFromRuler(A).galacticPowerIndex -
            playerFromRuler(B).galacticPowerIndex);

    if (chanceSucceeds(chance)) {
      final map =
          yesEffectOfAction(relation: _initialRelation, interactions: action);
      if (_initialRelation != map['relation']) {
        updateRelation(A, B, map['relation'] as Relation);
      }
      if (action == ChatOptions.help) {
        playerFromRuler(A).money += 5000; // TODO: Gift money here
      }
      notifyListeners();
      return map['response'] as String;
    } else {
      final map =
          noEffectOfAction(relation: _initialRelation, interactions: action);
      if (_initialRelation != map['relation']) {
        updateRelation(A, B, map['relation'] as Relation);
      }
      notifyListeners();
      return map['response'] as String;
    }
  }

  List<ChatOptions> possibleActions(Relation relation) {
    // ignore: prefer_final_locals
    List<ChatOptions> _list = [];
    switch (relation) {
      case Relation.war:
        _list.add(ChatOptions.peace);
        _list.add(ChatOptions.extortForPeace); // Will take money for Peace
        break;
      case Relation.trade:
        _list.add(ChatOptions.cancelTrade);
        _list.add(ChatOptions.help); // Ask for financial Help
        break;
      case Relation.peace:
        _list.add(ChatOptions.trade);
        _list.add(ChatOptions.war);
        break;
      default:
    }
    return _list;
  }

  bool chanceSucceeds(double chance) {
    return Random().nextInt(100) < (chance * 100).round();
  }

  String getRivalsOpinion(Ruler ruler) {
    // Return different opinions based on GPI difference, so player can get a rough idea of his position relatively
    // Is displayed under the Stats Panel
    int avgRivalGPI = 0;
    int rulerGPI = 0;
    for (final player in players) {
      if (player.ruler != ruler) {
        avgRivalGPI += player.galacticPowerIndex;
      } else {
        rulerGPI = player.galacticPowerIndex;
      }
    }
    avgRivalGPI = (avgRivalGPI / players.length - 1).floor();
    if (avgRivalGPI - rulerGPI > godlyDifference) {
      return "Your are nothing more then a insect for others";
    } else if (avgRivalGPI - rulerGPI > goodDifference) {
      return "They all are far advanced then you, and won't hesitate to kill you if need arises";
    } else if (avgRivalGPI - rulerGPI > almostEquals) {
      return "You stand on equal footing, Others rulers respect you";
    } else if (avgRivalGPI - rulerGPI > -almostEquals) {
      return 'The Aliens loves us and are a fan of your work';
    } else if (avgRivalGPI - rulerGPI > -goodDifference) {
      return 'The Aliens respect and fear your supreme strength';
    } else {
      return "There is no greater might than you in the universe at the moment";
    }
  }
}
