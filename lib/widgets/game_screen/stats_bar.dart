import 'package:flutter/material.dart';

class StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            Theme.of(context).primaryColor.withOpacity(0.4),
            Colors.black
          ], stops: [
            0.0,
            0.7,
            1.0
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '10,000 💲 |  ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Days : 1/999',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
