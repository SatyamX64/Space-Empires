import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:space_empires/models/planet_model.dart';
import 'interaction.dart';
import 'planet/planet.dart';
import '../models/rivals_model.dart';
import '../models/ruler_model.dart';
import 'player/player.dart';

const int kGameDays = 365;

class Game extends ChangeNotifier {
  int days;
  List<Player> players;
  List<String> galacticNews;
  Map<Ruler, Map<Ruler, RivalRelation>> galacticRelations;

  void initGame(Ruler selectedRuler) {
    initPlayers(selectedRuler);
    initGalacticRelations();
    resetGalacticNews();
    days = kGameDays;
    notifyListeners();
  }

  bool get lostGame => !(currentPlayer.planets.length > 0 && days > 0);

  bool get wonGame => (currentPlayer.planets.length == planets.length);

  void initPlayers(Ruler selectedRuler) {
    players = [];
    players.add(
      Player(
          planets: <Planet>[
            Planet(PlanetName.Miavis),
            Planet(PlanetName.Drukunides)
          ],
          ruler: Ruler.Morbo,
          playerType: selectedRuler != Ruler.Morbo
              ? PlayerType.COMPUTER
              : PlayerType.HUMAN),
    );
    players.add(
      Player(
          planets: <Planet>[Planet(PlanetName.Arth), Planet(PlanetName.Musk)],
          ruler: Ruler.Zapp,
          playerType: selectedRuler != Ruler.Zapp
              ? PlayerType.COMPUTER
              : PlayerType.HUMAN),
    );
    players.add(
      Player(
          planets: <Planet>[
            Planet(PlanetName.Jupinot),
            Planet(PlanetName.Ocorix)
          ],
          ruler: Ruler.NdNd,
          playerType: selectedRuler != Ruler.NdNd
              ? PlayerType.COMPUTER
              : PlayerType.HUMAN),
    );
    players.add(
      Player(
          planets: <Planet>[Planet(PlanetName.Eno), Planet(PlanetName.Hounus)],
          ruler: Ruler.Nudar,
          playerType: selectedRuler != Ruler.Nudar
              ? PlayerType.COMPUTER
              : PlayerType.HUMAN),
    );
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

  void resetGalacticNews() {
    galacticNews = [];
  }

  Player get currentPlayer {
    return players
        .firstWhere((player) => player.playerType == PlayerType.HUMAN);
  }

  List<Player> get computerPlayers {
    return List<Player>.from(
        players.where((player) => player.playerType == PlayerType.COMPUTER));
  }

  List<Planet> get planets {
    List<Planet> _planets = [];
    players.forEach((player) {
      _planets.addAll(player.planets);
    });
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
      if (player.planets.length == 0) {
        galacticNews.add(
            '${describeEnum(player.ruler)} died in the last battle. His galatic empire is over ');
        return true;
      } else
        return false;
    });
  }

  void changeOwnerOfPlanet({Ruler newRuler, PlanetName planetName}) {
    galacticNews.add(
        '${describeEnum(newRuler)} took over the Planet ${describeEnum(planetName)}');
    playerForPlanet(planetName).removePlanet(planetName);
    playerFromRuler(newRuler).addPlanet(Planet(planetName));
    notifyListeners();
  }

  nextTurn() {
    // TODO : The Function that runs on Each Turn, basically the game loop
    days--;
    giveTradeBenefits();
    players.forEach((player) {
      // Each Player gets their income from all their planets
      // They get their Attack ability back
      // Each Planet goes out of War
      player.nextTurn();
    });
    computerPlayers.forEach((player) {
      // Each computer player buys Military/Defense/Upgrades/Stats from available Money
      double rivalsAverageGPI = 0;
      for (Player rival in players) {
        if (rival.ruler != player.ruler) {
          rivalsAverageGPI += rival.galacticPowerIndex;
        }
      }
      rivalsAverageGPI /= players.length - 1;
      player.autoTurn((player.galacticPowerIndex - rivalsAverageGPI).toInt());
    });
    // Each Computer Player might change Relation with other races depending upon their GPI difference
    autoUpdateRelation();
    // Computer Attacks other computer Players
    computerAttacksComputer();
    notifyListeners();
    // Computer Attacks current player and info is passed back to game Screen

    players.forEach((player) {
      print(
          ' ${describeEnum(player.ruler)} ${player.money} ${player.galacticPowerIndex}');
    });
    return computerAttacksCurrentPlayer();
  }

  giveTradeBenefits() {
    for (Player A in players) {
      for (Player B in players) {
        if (relationBetweenRulers(A.ruler, B.ruler) == RivalRelation.Trade) {
          A.money += (B.money * 0.05).floor();
        }
      }
    }
  }

  autoUpdateRelation() {
    //TODO : Auto Update Relation Strategy

    // Update Relation among different Rulers based on GPI difference
    // Computer won't trade among themselves, neither will they ever propose Trade
    // Only the current Player can begin trading with computer
    // Although Computer can stop trading and revert back to peace
    // This is because trade needs acceptance from both parties
    // and we can't ask currentPlayer at this point to accept/reject a trade deal

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
                break;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.8)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
              case RivalRelation.War:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
            }
          } else if (diff > goodDifference) {
            // Player A is doing a lot better
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.6)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                break;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.6)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
              case RivalRelation.War:
                if (chanceSucceeds(0.3)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
            }
          } else if (diff > almostEquals) {
            // Both Players are almost at equal Footing, with A being slightly better
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.3)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                break;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.3)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
              case RivalRelation.War:
                if (chanceSucceeds(0.4)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
            }
          } else {
            // Player A is not in lead
            switch (relation) {
              case RivalRelation.Peace:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                break;
              case RivalRelation.Trade:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
              case RivalRelation.War:
                if (chanceSucceeds(0.1)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.Peace);
                }
                break;
            }
          }
        }
      }
    }
  }

  calculateChanceForAutoAttack({Player A, Player B}) {
    //TODO : Calculates Chances for Attack from Computer here

    int diff = A.galacticPowerIndex - B.galacticPowerIndex;
    if (diff > godlyDifference) {
      return 0.9;
    } else if (diff > goodDifference) {
      return 0.7;
    } else if (diff > almostEquals) {
      return 0.3;
    } else
      return 0.05;
  }

  void computerAttacksComputer() {
    for (Player attacker in computerPlayers) {
      for (Player defender in computerPlayers) {
        if (attacker.ruler != defender.ruler &&
            relationBetweenRulers(attacker.ruler, defender.ruler) ==
                RivalRelation.War &&
            attacker.canAttack) {
          double chance =
              calculateChanceForAutoAttack(A: attacker, B: defender);
          if (chanceSucceeds(chance)) {
            List<Planet> defenderPlanets = defender.planets;
            int selectedPlanetIndex = Random().nextInt(defenderPlanets.length);
            Planet defendingPlanet = defenderPlanets[selectedPlanetIndex];
            if (defendingPlanet.inWar) {
              // i.e the planet has already had a attack this day
              // So defense is likely very low
              // So We can't allow other to attack before next turn
              continue;
            }
            // diff in military might suggests, how well the attacking military and defenders fare off against each other
            // Attack will succeed if Military is clearly Superior
            int diffMilitaryMight =
                attacker.militaryMight - defendingPlanet.militaryMight;
            defendingPlanet.inWar = true;
            attacker.canAttack = false;
            if (diffMilitaryMight > godlyDifferenceMilitary) {
              attacker.destroyMilitary(Random().nextDouble() *
                  0.10); // 0-10% Military might be destroyed
              changeOwnerOfPlanet(
                  newRuler: attacker.ruler, planetName: defendingPlanet.name);
              removeDeadPlayers();
              break;
            } else if (diffMilitaryMight > goodDifferenceMilitary) {
              attacker.destroyMilitary(Random().nextDouble() * 0.30);
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

  Map computerAttacksCurrentPlayer() {
    for (Player attacker in computerPlayers) {
      Player defender = currentPlayer;
      if (relationBetweenRulers(attacker.ruler, defender.ruler) ==
              RivalRelation.War &&
          attacker.canAttack) {
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
    return null;
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

  // Each Player can perform only one Action with each player per turn
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
        playerFromRuler(A).money += 5000; // TODO: Gift money here
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
    // Return different opinions based on GPI difference, so player can get a rough idea of his position relatively
    // Is displayed under the Stats Panel
    int avgRivalGPI = 0;
    int rulerGPI = 0;
    for (Player player in players) {
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
      return "They all are far advanced then you, and won\'t hesitate to kill you if need arises";
    } else if (avgRivalGPI - rulerGPI > almostEquals) {
      return "You stand on equal footing, Others rulers respect you";
    } else if (avgRivalGPI - rulerGPI > -almostEquals)
      return 'The Aliens loves us and are a fan of your work';
    else if (avgRivalGPI - rulerGPI > -goodDifference)
      return 'The Aliens respect and fear your supreme strength';
    else
      return "There is no greater might than you in the universe at the moment";
  }
}
