import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:some_game/utility/interaction.dart';
import '../models/planet_model.dart';
import '../models/player_model.dart';
import '../models/rivals_model.dart';
import '../models/ruler_model.dart';

const int kGameDays = 365;

class Game extends ChangeNotifier {
  int days;
  List<Player> players;
  List<String> galacticNews;
  Map<Ruler, Map<Ruler, Map<String, dynamic>>> galacticRelations;
  Ruler selectedRuler;

  Game() {
    initGame();
  }

  void initGame() {
    initPlayers();
    initGalacticRelations();
    initGalacticNews();
    days = kGameDays;
  }

  bool get lostGame => !(currentPlayer.planets.length > 0 && days > 0);

  bool get wonGame => (currentPlayer.planets.length == planets.length);

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
          galacticRelations[_firstRuler][_secondRuler] = {
            'relation': RivalRelation.Peace,
            'attitude': RivalAttitude
                .Disregard, // what FIrst Ruler feels for Second Ruler
          };
        }
      }
    }
  }

  void initGalacticNews() {
    galacticNews = [];
    // I might add some tutorial here which should be shown on day 2
  }

  void initCurrentPlayer(Ruler value) {
    selectedRuler = value;
    notifyListeners();
  }

  void clearNews() {
    galacticNews = [];
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

  void nextTurn() {
    days--;
    players.forEach((player) {
      player.nextTurn();
    });
    computerPlayers.forEach((player) {
      player.autoTurn();
      print(' ${player.money} + ${player.galacticPowerIndex}');
    });
    if (days == 360) {}
    autoUpdateAttitude();
    // Relation Update
    // Computer Attack each other
    // Computer Attack CurrentPlayer
    // Computer AI does global Action like War

    notifyListeners();
    // returns a List of (attacker,PlanetitWillAttack)
  }

  autoUpdateAttitude() {
    // Update Attitude among different Rulers based on GPI and current Attitude
    for (Player computerPlayer in computerPlayers) {
      for (Player rivalPlayer in players) {
        if (rivalPlayer.ruler != computerPlayer.ruler) {
          int diff = computerPlayer.galacticPowerIndex -
              rivalPlayer.galacticPowerIndex;
          RivalAttitude attitude =
              attitudeTowardRival(computerPlayer.ruler, rivalPlayer.ruler);
          if (diff > 70) {
            updateAttitude(
                computerPlayer.ruler, rivalPlayer.ruler, RivalAttitude.Resents);
          } else if (diff > 50) {
            switch (attitude) {
              case RivalAttitude.Resents:
                break;
              default:
                if (chanceSucceeds(0.8)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Disregard);
                }
            }
          } else if (diff > 20) {
            switch (attitude) {
              case RivalAttitude.Scared:
                if (chanceSucceeds(0.8)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Disregard);
                }
                break;
              case RivalAttitude.Cordial:
                if (chanceSucceeds(0.3)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Disregard);
                }
                break;
              default:
                if (chanceSucceeds(0.4)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Cordial);
                }
                break;
            }
          } else if (diff > -30) {
            switch (attitude) {
              case RivalAttitude.Scared:
                if (chanceSucceeds(0.5)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Cordial);
                }
                break;
              default:
                if (chanceSucceeds(0.8)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Cordial);
                }
                break;
            }
          } else {
            if (chanceSucceeds(0.8)) {
              updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                  RivalAttitude.Scared);
            }
          }
        }
      }
    }
  }

  autoUpdateRelation() {
    // Update Attitude among different Rulers based on GPI and current Attitude
    for (Player computerPlayer in computerPlayers) {
      for (Player rivalPlayer in players) {
        if (rivalPlayer.ruler != computerPlayer.ruler) {
          int diff = computerPlayer.galacticPowerIndex -
              rivalPlayer.galacticPowerIndex;
          RivalRelation relation =
              relationBetweenRulers(computerPlayer.ruler, rivalPlayer.ruler);
          RivalAttitude attitude =
              attitudeTowardRival(computerPlayer.ruler, rivalPlayer.ruler);
          if (diff > 70) {
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
              default:
                break;
            }
          } else if (diff > 50) {
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
              default:
                break;
            }
          } else if (diff > 20) {
            switch (relation) {
              case RivalRelation.War:
                switch (attitude) {
                  case RivalAttitude.Resents:
                    if (chanceSucceeds(0.2)) {
                      updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                          RivalRelation.Peace);
                    }
                    break;
                  case RivalAttitude.Disregard:
                    if (chanceSucceeds(0.6)) {
                      updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                          RivalRelation.Peace);
                    }
                    break;
                  default:
                    if (chanceSucceeds(0.2)) {
                      updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                          RivalRelation.Peace);
                    }
                    break;
                }
                if (chanceSucceeds(0.6)) {
                  updateRelation(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalRelation.War);
                }
                break;
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
              default:
                break;
            }
          } else if (diff > -30) {
            switch (attitude) {
              case RivalAttitude.Scared:
                if (chanceSucceeds(0.5)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Cordial);
                }
                break;
              default:
                if (chanceSucceeds(0.8)) {
                  updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                      RivalAttitude.Cordial);
                }
                break;
            }
          } else {
            if (chanceSucceeds(0.8)) {
              updateAttitude(computerPlayer.ruler, rivalPlayer.ruler,
                  RivalAttitude.Scared);
            }
          }
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
    return galacticRelations[A][B]['relation'];
  }

  RivalAttitude attitudeTowardRival(Ruler A, Ruler B) {
    return galacticRelations[A][B]['attitude'];
  }

  void updateRelation(Ruler A, Ruler B, RivalRelation relation) {
    galacticRelations[A][B]['relation'] = relation;
  }

  void updateAttitude(Ruler A, Ruler B, RivalAttitude attitude) {
    galacticRelations[A][B]['attitude'] = attitude;
  }

  // A sends to B

  // Rival can perform only one Action per turn
  // So you can't ask for war if started trading/peace etc
  String interactWithRival({RivalInteractions action, Ruler A, Ruler B}) {
    RivalAttitude _attitude = attitudeTowardRival(B, A);
    RivalRelation _relation = relationBetweenRulers(A, B);
    double chance = calculateChance(
        attitude: _attitude, relation: _relation, interactions: action);

    if (chanceSucceeds(chance)) {
      Map map = yesEffectOfAction(
          attitude: _attitude, relation: _relation, interactions: action);
      updateAttitude(B, A, map['attitude']);
      updateRelation(A, B, map['relation']);
      notifyListeners();
      return map['response'];
    } else {
      Map map = noEffectOfAction(
          attitude: _attitude, relation: _relation, interactions: action);
      updateAttitude(B, A, map['attitude']);
      updateRelation(A, B, map['relation']);
      notifyListeners();
      return map['response'];
    }
  }

  List<RivalInteractions> possibleActions(RivalRelation relation) {
    List<RivalInteractions> _list = [
      RivalInteractions.Gift, // Give money to improve Attitude
    ];
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
    // ideally compare  the currentPlayers with other players and give decision based on that
    return 'The Aliens choose to ignore us\nHave better things at hand';
  }
}
