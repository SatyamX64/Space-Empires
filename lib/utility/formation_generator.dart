import 'package:some_game/models/attack_ships_model.dart';
class FormationGenerator {
  List<List<int>> _formations = [];

  FormationGenerator() {
    var data = List.generate(kAttackShipsData.length, (index) => index);
    generateFormations(data, []);
  }
  void generateFormations(List<int> dataValue, List<int> currPerm) {
    for (var i = 0; i < dataValue.length; i++) {
      currPerm.add(dataValue[i]);
      if (currPerm.length == dataValue.length) {
        _formations.add(List.from(currPerm));
        currPerm.removeLast();
      } else {
        generateFormations(dataValue, currPerm);
      }
    }
    if (currPerm.isNotEmpty) {
      currPerm.removeLast();
    }
  }

  List<List<int>> get formations {
    return _formations;
  }
}
