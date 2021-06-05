import '/models/attack_ships_model.dart';
import 'package:flutter/material.dart';

// If given a list [1,2] it will store all possible permutations with repetation allowed
// i.e [1,1],[1,2],[2,1],[2,1]

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

class FormationProvider extends ChangeNotifier {
  List<List<int>> _formations;
  int _selectedFormation;

  FormationProvider() {
    _formations = FormationGenerator().formations;
    this._selectedFormation = 0;
  }

  List<int> get currentFormation {
    return _formations[_selectedFormation];
  }

  List<List<int>> get formations {
    return _formations;
  }

  changeFormation(index) {
    _selectedFormation = index;
    notifyListeners();
  }
}
