import '/models/rivals_model.dart';

// TODO : Difference in Galactic Power Index
const int godlyDifference = 70;
const int goodDifference = 50;
const int almostEquals = 20;

Map yesEffectOfAction(
    {RivalRelation relation, RivalInteractions interactions}) {
  Map map = {
    'relation': relation,
    'response': 'Ah, fair enough',
  };

  switch (interactions) {
    case RivalInteractions.CancelTrade:
      map['response'] =
          "If that\'s what you want..The Peace shall still remain";
      map['relation'] = RivalRelation.Peace;
      break;
    case RivalInteractions.ExtortForPeace:
      map['response'] =
          "I will comply to your terms, here is the money for Peace";
      map['relation'] = RivalRelation.Peace;
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
      break;
    case RivalInteractions.War:
      map['relation'] = RivalRelation.War;
      map['response'] = 'Haha Fool, Prepare to DIE  ';
      break;
  }
  return map;
}

Map noEffectOfAction({RivalRelation relation, RivalInteractions interactions}) {
  Map map = {
    'relation': relation,
    'response': 'Don\'t test my patience, fool',
  };

  switch (interactions) {
    case RivalInteractions
        .ExtortForPeace: // Ask money for Peace, Happens only when in War
      map['response'] = "You just invited your death";
      break;
    case RivalInteractions.Help:
      map['response'] = 'Don\'t try to abuse our friendship ';
      map['relation'] = RivalRelation.Peace;
      break;
    case RivalInteractions.Peace:
      map['response'] = 'You can\'t get out now, weakling';
      break;
    case RivalInteractions.Trade:
      map['response'] = 'Trade with your primitive race, no thanks';
      break;
    case RivalInteractions.War:
      map['response'] = 'War only brings peril for all, Please re-consider';
      break;
    default:
  }
  return map;
}


// TODO : Calculates chance on weather a interaction will Succeed or not
double calculateChance(
    {RivalRelation relation, RivalInteractions interactions, int diffGPI}) {
  switch (interactions) {
    case RivalInteractions.War: // Declare War only available in Peace
      return 0.9;
    case RivalInteractions.CancelTrade:
      return 1;
    case RivalInteractions
        .ExtortForPeace: // Takes money for Peace, can only happen in War
    case RivalInteractions
        .Help: // Ask for money polietly only available in trade
    case RivalInteractions.Peace: // Consider Peace only available in War
    case RivalInteractions.Trade: // Consider Trade only available in Peace
    default:
      if (diffGPI > godlyDifference) {
        // godly Difference
        return 0.8;
      } else if (diffGPI > goodDifference) {
        // good Difference
        return 0.6;
      } else if (diffGPI > almostEquals) {
        // equal-decent Difference
        return 0.3;
      }
      return 0.1;
  }
}
