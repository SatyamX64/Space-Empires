import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:some_game/models/planet_model.dart';
import 'package:some_game/models/player_model.dart';
import 'package:some_game/models/rivals_model.dart';

enum Ruler {
  NdNd,
  Morbo,
  Nudar,
  Zapp,
}

enum RivalInteractions {
  Gift,
  Trade,
  Help,
  Extort,
  Peace,
  CancelTrade,
  War,
}

class GameData extends ChangeNotifier {
  int days;
  List<Player> players = [];
  Map<Ruler, Map<Ruler, Map<String, dynamic>>> globalRelations;
  int selectedPlayerIndex;

  GameData() {
    initPlayers();
    initGlobalRelations();
    days = 365;
  }

  resetAllData() {
    players = [];
    globalRelations = {};
    selectedPlayerIndex = null;
    days = 365;
    initPlayers();
    initGlobalRelations();
  }

  initPlayers() {
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

  initGlobalRelations() {
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

  initCurrentPlayer(Ruler value) {
    selectedPlayerIndex =
        players.indexWhere((element) => element.ruler == value);
    notifyListeners();
  }

  Player get currentPlayer {
    return players[selectedPlayerIndex];
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
  }

  Player playerFromRuler(Ruler ruler) {
    return players.firstWhere((player) => player.ruler == ruler);
  }

  Player playerForPlanet(PlanetName planetName) {
    return players.firstWhere((player) => player.isPlanetMy(name: planetName));
  }

  changeOwnerOfPlanet({Ruler newRuler, PlanetName name}) {
    playerForPlanet(name).removePlanet(name);
    playerFromRuler(newRuler).addPlanet(Planet(name));
    notifyListeners();
  }

  nextTurn() {
    days--;
    players.forEach((player) {
      player.nextTurn();
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

  setRelation(Ruler A, Ruler B, RivalRelation relation) {
    globalRelations[A][B]['relation'] = relation;
  }

  setMood(Ruler A, Ruler B, RivalMood mood) {
    globalRelations[A][B]['mood'] = mood;
  }

  // A sends to B
  String interactWithRival({RivalInteractions action, Ruler A, Ruler B}) {
    RivalMood _mood = getMood(B, A);
    RivalRelation _relation = getRelation(A, B);
    double chance =
        calculateChance(mood: _mood, relation: _relation, interactions: action);

    if (!chanceSuccedds(chance)) {
      // remove !
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

  possibleActions(RivalRelation relation) {
    List<RivalInteractions> _list = [
      RivalInteractions.Gift, // Give money to improve Mood
    ];
    switch (relation) {
      case RivalRelation.War:
        _list.add(RivalInteractions.Peace);
        _list.add(RivalInteractions.Extort); // Will take money for Peace
        break;
      case RivalRelation.Trade:
        _list.add(RivalInteractions.CancelTrade);
        _list.add(RivalInteractions.Help);
        break;
      case RivalRelation.Peace:
        _list.add(RivalInteractions.Trade);
        _list.add(RivalInteractions.War);
        break;
    }
    return _list;
  }

  bool chanceSuccedds(double chance) {
    return Random().nextInt(100) < (chance * 100).round();
  }

  String getRivalsOpinion(Ruler ruler) {
    // ideally compare the currentPlayers with other players and give decision based on that
    // can also take Player as a parameter
    return 'The Aliens choose to ignore us\nHave better things at hand';
  }
}

// Rival can perform only one Action per turn
// So you can't ask for war if started trading/peace etc

Map yesEffectOfAction(
    {RivalMood mood, RivalRelation relation, RivalInteractions interactions}) {
  Map map = {
    'relation': relation,
    'mood': RivalMood.Cordial,
    'response': 'Ah, fair enough',
  };

  return map;
  // switch(interactions){
  //   case RivalInteractions.CancelTrade : break;
  //   case RivalInteractions.Extort :
  //     switch(relation){
  //       case RivalRelation.War :
  //       case RivalRelation.Trade :
  //       case RivalRelation.Peace :
  //       mood = RivalMood.Resents;
  //       break;
  //     }
  //     break;
  //   case RivalInteractions.Gift : switch(relation){
  //       case RivalRelation.War :
  //       case RivalRelation.Trade :
  //       case RivalRelation.Peace :
  //       mood = RivalMood.Cordial;
  //       break;
  //     }
  //     break;
  //   case RivalInteractions.Help : switch(relation){
  //       case RivalRelation.War :
  //       case RivalRelation.Trade :
  //       case RivalRelation.Peace :
  //         switch(mood){
  //           case RivalMood.Disregard : return 0.1;
  //           case RivalMood.Resents : return 0.01;
  //           case RivalMood.Scared : return 0.4;
  //           case RivalMood.Cordial : return 0.2;
  //       }
  //     }
  //     break;
  //   case RivalInteractions.Peace : switch(relation){
  //       case RivalRelation.War : switch(mood){
  //           case RivalMood.Disregard : return 0.1;
  //           case RivalMood.Resents : return 0.01;
  //           case RivalMood.Scared : return 0.8;
  //           case RivalMood.Cordial : return 0.5;
  //       } break;
  //       case RivalRelation.Trade : return 0;
  //       case RivalRelation.Peace : return 0;
  //     }
  //     break;
  //   case RivalInteractions.Trade : switch(relation){
  //       case RivalRelation.War : return 0;
  //       case RivalRelation.Trade : return 0;
  //       case RivalRelation.Peace :
  //         switch(mood){
  //           case RivalMood.Disregard : return 0.1;
  //           case RivalMood.Resents : return 0.01;
  //           case RivalMood.Scared : return 0.3;
  //           case RivalMood.Cordial : return 0.4;
  //       }
  //     }
  //     break;
  //   case RivalInteractions.War : switch(relation){
  //       case RivalRelation.War : return 0;
  //       case RivalRelation.Trade : return 0;
  //       case RivalRelation.Peace :
  //         switch(mood){
  //           case RivalMood.Disregard : return 0.95;
  //           case RivalMood.Resents : return 1;
  //           case RivalMood.Scared : return 0.8;
  //           case RivalMood.Cordial : return 0.8;
  //       }
  //     }
  //     break;
  // }
}

Map noEffectOfAction(
    {RivalMood mood, RivalRelation relation, RivalInteractions interactions}) {
  Map map = {
    'relation': RivalRelation.War,
    'mood': RivalMood.Resents,
    'response': 'now you\'ll die'
  };

  return map;
  // switch(interactions){
  //   case RivalInteractions.CancelTrade : break;
  //   case RivalInteractions.Extort :
  //     switch(relation){
  //       case RivalRelation.War :
  //       case RivalRelation.Trade :
  //       case RivalRelation.Peace :
  //       mood = RivalMood.Resents;
  //       break;
  //     }
  //     break;
  //   case RivalInteractions.Gift : switch(relation){
  //       case RivalRelation.War :
  //       case RivalRelation.Trade :
  //       case RivalRelation.Peace :
  //       mood = RivalMood.Cordial;
  //       break;
  //     }
  //     break;
  //   case RivalInteractions.Help : switch(relation){
  //       case RivalRelation.War :
  //       case RivalRelation.Trade :
  //       case RivalRelation.Peace :
  //         switch(mood){
  //           case RivalMood.Disregard : return 0.1;
  //           case RivalMood.Resents : return 0.01;
  //           case RivalMood.Scared : return 0.4;
  //           case RivalMood.Cordial : return 0.2;
  //       }
  //     }
  //     break;
  //   case RivalInteractions.Peace : switch(relation){
  //       case RivalRelation.War : switch(mood){
  //           case RivalMood.Disregard : return 0.1;
  //           case RivalMood.Resents : return 0.01;
  //           case RivalMood.Scared : return 0.8;
  //           case RivalMood.Cordial : return 0.5;
  //       } break;
  //       case RivalRelation.Trade : return 0;
  //       case RivalRelation.Peace : return 0;
  //     }
  //     break;
  //   case RivalInteractions.Trade : switch(relation){
  //       case RivalRelation.War : return 0;
  //       case RivalRelation.Trade : return 0;
  //       case RivalRelation.Peace :
  //         switch(mood){
  //           case RivalMood.Disregard : return 0.1;
  //           case RivalMood.Resents : return 0.01;
  //           case RivalMood.Scared : return 0.3;
  //           case RivalMood.Cordial : return 0.4;
  //       }
  //     }
  //     break;
  //   case RivalInteractions.War : switch(relation){
  //       case RivalRelation.War : return 0;
  //       case RivalRelation.Trade : return 0;
  //       case RivalRelation.Peace :
  //         switch(mood){
  //           case RivalMood.Disregard : return 0.95;
  //           case RivalMood.Resents : return 1;
  //           case RivalMood.Scared : return 0.8;
  //           case RivalMood.Cordial : return 0.8;
  //       }
  //     }
  //     break;
  // }
}

double calculateChance(
    {RivalMood mood, RivalRelation relation, RivalInteractions interactions}) {
  switch (interactions) {
    case RivalInteractions.CancelTrade:
      return 1;
    case RivalInteractions.Extort:
      switch (relation) {
        case RivalRelation.War:
        case RivalRelation.Trade:
          return 0;
        case RivalRelation.Peace:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.1;
            case RivalMood.Resents:
              return 0.01;
            case RivalMood.Scared:
              return 0.4;
            case RivalMood.Cordial:
              return 0.2;
          }
      }
      break;
    case RivalInteractions.Gift:
      switch (relation) {
        case RivalRelation.War:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.1;
            case RivalMood.Resents:
              return 0.01;
            case RivalMood.Scared:
              return 0.9;
            case RivalMood.Cordial:
              return 0.2;
          }
          break;
        case RivalRelation.Trade:
          return 1;
        case RivalRelation.Peace:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.1;
            case RivalMood.Resents:
              return 0.01;
            case RivalMood.Scared:
              return 0.7;
            case RivalMood.Cordial:
              return 0.3;
          }
      }
      break;
    case RivalInteractions.Help:
      switch (relation) {
        case RivalRelation.War:
        case RivalRelation.Trade:
          return 0;
        case RivalRelation.Peace:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.1;
            case RivalMood.Resents:
              return 0.01;
            case RivalMood.Scared:
              return 0.4;
            case RivalMood.Cordial:
              return 0.2;
          }
      }
      break;
    case RivalInteractions.Peace:
      switch (relation) {
        case RivalRelation.War:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.1;
            case RivalMood.Resents:
              return 0.01;
            case RivalMood.Scared:
              return 0.8;
            case RivalMood.Cordial:
              return 0.5;
          }
          break;
        case RivalRelation.Trade:
          return 0;
        case RivalRelation.Peace:
          return 0;
      }
      break;
    case RivalInteractions.Trade:
      switch (relation) {
        case RivalRelation.War:
          return 0;
        case RivalRelation.Trade:
          return 0;
        case RivalRelation.Peace:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.1;
            case RivalMood.Resents:
              return 0.01;
            case RivalMood.Scared:
              return 0.3;
            case RivalMood.Cordial:
              return 0.4;
          }
      }
      break;
    case RivalInteractions.War:
      switch (relation) {
        case RivalRelation.War:
          return 0;
        case RivalRelation.Trade:
          return 0;
        case RivalRelation.Peace:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.95;
            case RivalMood.Resents:
              return 1;
            case RivalMood.Scared:
              return 0.8;
            case RivalMood.Cordial:
              return 0.8;
          }
      }
      break;
    default:
      return 0.0;
  }
}
