import 'package:flutter/material.dart';
import '/models/attack_ships_model.dart';
import '/models/defense_ships_model.dart';

class AttackerFormationPainter extends CustomPainter {
  final List<int> formation;
  AttackerFormationPainter({required this.formation})
      : assert(formation.length == kAttackShipsData.length &&
            formation.length == kDefenseShipsData.length);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // ignore: prefer_final_locals
    List<Offset> startingPoints = [];
    // ignore: prefer_final_locals
    List<Offset> endPoints = [];

    for (int i = 1; i < formation.length * 2; i += 2) {
      startingPoints.add(Offset(0, size.height / (formation.length * 2) * i));
      endPoints
          .add(Offset(size.width, size.height / (formation.length * 2) * i));
    }

    for (int i = 0; i < formation.length; i++) {
      canvas.drawLine(startingPoints[i], endPoints[formation[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DefenderFormationPainter extends CustomPainter {
  final List<int> formation;
  DefenderFormationPainter({required this.formation})
      : assert(formation.length == kAttackShipsData.length &&
            formation.length == kDefenseShipsData.length);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // ignore: prefer_final_locals
    List<Offset> startingPoints = [];
    // ignore: prefer_final_locals
    List<Offset> endPoints = [];

    for (int i = 1; i < formation.length * 2; i += 2) {
      startingPoints.add(Offset(0, size.height / (formation.length * 2) * i));
      endPoints
          .add(Offset(size.width, size.height / (formation.length * 2) * i));
    }

    for (int i = 0; i < formation.length; i++) {
      canvas.drawLine(endPoints[i], startingPoints[formation[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
