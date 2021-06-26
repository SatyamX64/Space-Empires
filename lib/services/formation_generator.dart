import 'package:flutter/material.dart';

import '/models/attack_ships_model.dart';

// If given a list [1,2] it will store all possible permutations with repetation allowed
// i.e [1,1],[1,2],[2,1],[2,1]

class FormationGenerator {
  // ignore: prefer_final_fields
  List<List<int>> _formations = [];

  FormationGenerator() {
    final data = List.generate(kAttackShipsData.length, (index) => index);
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
  late List<List<int>> _formations;
  late int _selectedFormation;

  FormationProvider() {
    _formations = FormationGenerator().formations;
    _selectedFormation = 0;
  }

  List<int> get currentFormation {
    return _formations[_selectedFormation];
  }

  List<List<int>> get formations {
    return _formations;
  }

  void changeFormation(int index) {
    _selectedFormation = index;
    notifyListeners();
  }
}
