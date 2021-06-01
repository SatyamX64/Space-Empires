import 'package:some_game/models/rivals_model.dart';

Map yesEffectOfAction(
    {RivalMood mood, RivalRelation relation, RivalInteractions interactions}) {
  Map map = {
    'relation': relation,
    'mood': mood,
    'response': 'Ah, fair enough',
  };

  switch (interactions) {
    case RivalInteractions.CancelTrade:
      map['response'] =
          "If that\'s what you want..The Peace shall still remain";
      map['relation'] = RivalRelation.Peace;
      break;
    case RivalInteractions.ExtortForPeace: // Ask money for Peace
      map['response'] =
          "I will comply to your terms, here is the money for Peace";
      map['mood'] = RivalMood.Resents;
      map['relation'] = RivalRelation.Peace;
      break;
    case RivalInteractions.Gift:
      map['mood'] = RivalMood.Cordial;
      map['response'] = 'That\'s so sweet of you';
      break;
    case RivalInteractions.Help:
      map['response'] = 'Let me know if you need anything else, friend';
      break;
    case RivalInteractions.Peace:
      map['response'] = 'Okay okay, We stay out of each other buisness ';
      map['relation'] = RivalRelation.Peace;
      break;
    case RivalInteractions.Trade:
      map['relation'] = RivalRelation.Trade;
      map['response'] = 'It will be my pleasure';
      map['mood'] = RivalMood.Cordial;
      break;
    case RivalInteractions.War:
      map['relation'] = RivalRelation.War;
      map['mood'] = RivalMood.Resents;
      map['response'] = 'Haha Fool, Prepare to DIE  ';
      break;
  }
  return map;
}

Map noEffectOfAction(
    {RivalMood mood, RivalRelation relation, RivalInteractions interactions}) {
  Map map = {
    'relation': relation,
    'mood': mood,
    'response': 'Don\'t test my patience, fool',
  };

  switch (interactions) {
    case RivalInteractions.ExtortForPeace: // Ask money for Peace
      map['response'] = "You just invited your death";
      map['mood'] = RivalMood.Resents;
      map['relation'] = RivalRelation.War;
      break;
    case RivalInteractions.Gift:
      map['mood'] = RivalMood.Resents;
      map['response'] = 'I don\'t need your puny gifts';
      break;
    case RivalInteractions.Help:
      map['response'] = 'Don\'t try to abuse our friendship ';
      map['relation'] = RivalRelation.Peace;
      map['mood'] = RivalMood.Disregard;
      break;
    case RivalInteractions.Peace:
      map['response'] = 'You can\'t get out now, weakling';
      map['mood'] = RivalMood.Resents;
      break;
    case RivalInteractions.Trade:
      map['response'] = 'Trade with your primitive race, no thanks';
      break;
    case RivalInteractions.War:
      map['mood'] = RivalMood.Scared;
      map['response'] = 'War only brings peril for all, Please re-consider';
      break;
    default:
  }
  return map;
}

double calculateChance(
    {RivalMood mood, RivalRelation relation, RivalInteractions interactions}) {
  switch (interactions) {
    case RivalInteractions.CancelTrade:
      return 1;
    case RivalInteractions
        .ExtortForPeace: // Takes money for Peace, can only happen in War
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
      break;
    case RivalInteractions.Gift:
      switch (relation) {
        case RivalRelation.War:
          switch (mood) {
            case RivalMood.Disregard:
              return 0.15;
            case RivalMood.Resents:
              return 0.05;
            case RivalMood.Scared:
              return 0.7;
            case RivalMood.Cordial:
              return 0.2;
          }
          break;
        case RivalRelation.Trade:
          return 0.8;
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
    case RivalInteractions
        .Help: // Ask for money polietly only available in trade
      switch (mood) {
        case RivalMood.Disregard:
          return 0.1;
        case RivalMood.Resents:
          return 0.01;
        case RivalMood.Scared:
          return 0.4;
        case RivalMood.Cordial:
          return 0.6;
      }
      break;
    case RivalInteractions.Peace: // Consider Peace only available in War
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
    case RivalInteractions.Trade: // Consider Trade only available in Peace
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
      break;
    case RivalInteractions.War: // Declare War only available in Peace
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
      break;
    default:
      return 0.0;
  }
}
