import '../models/interaction_model.dart';

// TODO : Difference in Galactic Power Index
const int godlyDifference = 300;
const int goodDifference = 160;
const int almostEquals = 40;

const int godlyDifferenceMilitary = 200;
const int goodDifferenceMilitary = 100;
const int almostEqualsMilitary = 50;

Map yesEffectOfAction({Relation? relation, ChatOptions? interactions}) {
  // ignore: prefer_final_locals
  Map map = {
    'relation': relation,
    'response': 'Ah, fair enough',
  };

  switch (interactions) {
    case ChatOptions.cancelTrade:
      map['response'] = "If that's what you want..The Peace shall still remain";
      map['relation'] = Relation.peace;
      break;
    case ChatOptions.extortForPeace:
      map['response'] =
          "I will comply to your terms, here is the money for Peace";
      map['relation'] = Relation.peace;
      break;
    case ChatOptions.help:
      map['response'] = 'Let me know if you need anything else, friend';
      break;
    case ChatOptions.peace:
      map['response'] = 'Okay okay, We stay out of each other buisness ';
      map['relation'] = Relation.peace;
      break;
    case ChatOptions.trade:
      map['relation'] = Relation.trade;
      map['response'] = 'It will be my pleasure';
      break;
    case ChatOptions.war:
      map['relation'] = Relation.war;
      map['response'] = 'Haha Fool, Prepare to DIE  ';
      break;
    default:
      break;
  }
  return map;
}

Map noEffectOfAction({Relation? relation, ChatOptions? interactions}) {
  // ignore: prefer_final_locals
  Map map = {
    'relation': relation,
    'response': "Don't test my patience, fool",
  };

  switch (interactions) {
    case ChatOptions
        .extortForPeace: // Ask money for Peace, Happens only when in War
      map['response'] = "You just invited your death";
      break;
    case ChatOptions.help:
      map['response'] = "Don't try to abuse our friendship ";
      map['relation'] = Relation.peace;
      break;
    case ChatOptions.peace:
      map['response'] = "You can't get out now, weakling";
      break;
    case ChatOptions.trade:
      map['response'] = "Trade with your primitive race, no thanks";
      break;
    case ChatOptions.war:
      map['response'] = "War only brings peril for all, Please re-consider";
      break;
    default:
  }
  return map;
}

// TODO : Calculates chance on weather a interaction will Succeed or not
double calculateChance(
    {Relation? relation, ChatOptions? interactions, int? diffGPI}) {
  switch (interactions) {
    case ChatOptions.war: // Declare War only available in Peace
      return 0.9;
    case ChatOptions.cancelTrade:
      return 1;
    case ChatOptions
        .extortForPeace: // Takes money for Peace, can only happen in War
    case ChatOptions.help: // Ask for money polietly only available in trade
    case ChatOptions.peace: // Consider Peace only available in War
    case ChatOptions.trade: // Consider Trade only available in Peace
    default:
      if (diffGPI! > godlyDifference) {
        return 0.8;
      } else if (diffGPI > goodDifference) {
        return 0.6;
      } else if (diffGPI > almostEquals) {
        return 0.3;
      }
      return 0.1;
  }
}
