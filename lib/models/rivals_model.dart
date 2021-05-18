import 'game_data.dart';
import 'planet_model.dart';

enum RivalRelation {
  Trade,
  War,
  Peace,
}

enum RivalMood {
  Cordial,
  Scared,
  Disregard,
  Resents,
}

class Rival {
  Ruler ruler;
  RivalRelation relation;
  RivalMood mood;

  Rival.NdNd() {
    ruler = Ruler.NdNd;
    mood = RivalMood.Resents;
    relation = RivalRelation.Peace;
  }
  Rival.Morbo() {
    ruler = Ruler.Morbo;
    mood = RivalMood.Cordial;
    relation = RivalRelation.Trade;
  }
  Rival.Nudar() {
    ruler = Ruler.Nudar;
    mood = RivalMood.Scared;
    relation = RivalRelation.War;
  }
}

List<Rival> rivalsList = [Rival.Morbo(), Rival.NdNd(), Rival.Nudar()];
