import 'package:flutter/material.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/instructions.dart';
import 'package:url_launcher/url_launcher.dart';

const _url =
    "https://www.youtube.com/watch?v=KxGRhd_iWuE&ab_channel=Ryuujin131"; // Will be project's github link

class InstructionScreen extends StatelessWidget {
  static const route = '/instruction-screen';
  _spaceLights() {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            opacityBlack(0.3),
            kMaroon,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Instructions',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontFamily: 'Italianno'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _spaceLights(),
          ListView.separated(
            itemBuilder: (_, index) {
              return ExpansionTile(
                title: Text(
                  List.from(kInstructionsData.keys)[index],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                childrenPadding: EdgeInsets.all(16),
                children: [
                  Text(List.from(kInstructionsData.values)[index]),
                ],
              );
            },
            itemCount: kInstructionsData.length,
            separatorBuilder: (_, __) => Divider(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.star),
        onPressed: _launchURL,
        backgroundColor: Color(0xFFF1972B),
      ),
    );
  }
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
