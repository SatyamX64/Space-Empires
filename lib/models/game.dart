import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:some_game/utility/interaction.dart';
import 'planet_model.dart';
import 'player_model.dart';
import 'rivals_model.dart';
import 'ruler_model.dart';

class Game extends ChangeNotifier {
  int days;
  List<Player> players = [];
  List<String> globalNews = [];
  Map<Ruler, Map<Ruler, Map<String, dynamic>>> globalRelations;
  Ruler selectedRuler;

  Game() {
    initPlayers();
    initGlobalRelations();
    days = 365;
  }

  bool get lostGame => !(currentPlayer.planets.length > 0 && days > 0);

  bool get wonGame => (currentPlayer.planets.length == planets.length);

  void resetAllData() {
    players = [];
    globalRelations = {};
    globalNews = [];
    selectedRuler = null;
    days = 365;
    initPlayers();
    initGlobalRelations();
  }

  void initPlayers() {
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

  void initGlobalRelations() {
    globalRelations = {
      Ruler.NdNd: {
        Ruler.Nudar: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard, // what NdNd feels for Nudar
        },
        Ruler.Morbo: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.Zapp: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
      },
      Ruler.Morbo: {
        Ruler.Nudar: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.NdNd: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.Zapp: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
      },
      Ruler.Zapp: {
        Ruler.Nudar: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.Morbo: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.NdNd: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
      },
      Ruler.Nudar: {
        Ruler.NdNd: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.Morbo: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
        Ruler.Zapp: {
          'relation': RivalRelation.Peace,
          'mood': RivalMood.Disregard,
        },
      }
    };
  }

  void initCurrentPlayer(Ruler value) {
    selectedRuler = value;
    notifyListeners();
  }

  void clearNews() {
    globalNews = [];
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
    players.removeWhere((player) {
      if (player.planets.length == 0) {
        globalNews.add(
            '${describeEnum(player.ruler)} died in the last battle. His galatic empire is over ');
        return true;
      } else
        return false;
    });
  }

  void changeOwnerOfPlanet({Ruler newRuler, PlanetName name}) {
    globalNews.add(
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
      print(player.money);
    });
    notifyListeners();
  }

  List<Planet> getEnemyPlanets(Ruler ruler) {
    List<Planet> enemyPlanets = [];
    players.forEach((player) {
      if (ruler != player.ruler) {
        if (getRelation(ruler, player.ruler) == RivalRelation.War) {
          enemyPlanets.addAll(player.planets);
        }
      }
    });
    return enemyPlanets;
  }

  String getPlanetDescription(PlanetName name) {
    return planets.firstWhere((planet) => planet.name == name).description;
  }

  RivalRelation getRelation(Ruler A, Ruler B) {
    return globalRelations[A][B]['relation'];
  }

  RivalMood getMood(Ruler A, Ruler B) {
    return globalRelations[A][B]['mood'];
  }

  void setRelation(Ruler A, Ruler B, RivalRelation relation) {
    globalRelations[A][B]['relation'] = relation;
  }

  void setMood(Ruler A, Ruler B, RivalMood mood) {
    globalRelations[A][B]['mood'] = mood;
  }

  // A sends to B

  // Rival can perform only one Action per turn
  // So you can't ask for war if started trading/peace etc
  String interactWithRival({RivalInteractions action, Ruler A, Ruler B}) {
    RivalMood _mood = getMood(B, A);
    RivalRelation _relation = getRelation(A, B);
    double chance =
        calculateChance(mood: _mood, relation: _relation, interactions: action);

    if (chanceSucceeds(chance)) {
      Map map = yesEffectOfAction(
          mood: _mood, relation: _relation, interactions: action);
      setMood(B, A, map['mood']);
      setRelation(A, B, map['relation']);
      notifyListeners();
      return map['response'];
    } else {
      Map map = noEffectOfAction(
          mood: _mood, relation: _relation, interactions: action);
      setMood(B, A, map['mood']);
      setRelation(A, B, map['relation']);
      notifyListeners();
      return map['response'];
    }
  }

  List<RivalInteractions> possibleActions(RivalRelation relation) {
    List<RivalInteractions> _list = [
      RivalInteractions.Gift, // Give money to improve Mood
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
    // ideally compare the currentPlayers with other players and give decision based on that
    // can also take Player as a parameter
    return 'The Aliens choose to ignore us\nHave better things at hand';
  }
}
