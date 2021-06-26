import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import '/services/game.dart';
import '/utility/constants.dart';

class AttackConclusionScreen extends StatelessWidget {
  static const route = '/attack-conclusion-screen.dart';
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as String? ?? "How did you come here ?";

    Widget _proceedButton() {
      return Padding(
        padding: EdgeInsets.all(16.sp),
        child: GestureDetector(
          onTap: () {
            Provider.of<Game>(context, listen: false).removeDeadPlayers();
            Navigator.of(context).pop();
          },
          child: Container(
              height: 40.sp,
              width: 160.sp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Palette.maroon,
                  borderRadius: BorderRadius.circular(50.sp)),
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
        ),
      );
    }

    Widget _dialogue(Orientation orientation) {
      return Container(
        alignment: orientation == Orientation.landscape
            ? Alignment.center
            : Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 72.sp),
        child: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(message,
                textStyle: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)
          ],
          repeatForever: true,
        ),
      );
    }

    Widget _portrait() {
      return Stack(
        children: [
          Center(child: FlyingShips()),
          _dialogue(Orientation.portrait),
          Align(
            alignment: Alignment.bottomCenter,
            child: _proceedButton(),
          ),
        ],
      );
    }

    Widget _landscape() {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Flexible(child: FlyingShips()),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  child: _proceedButton(),
                ),
              ],
            ),
          ),
          Expanded(child: _dialogue(Orientation.landscape)),
        ],
      );
    }

    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: const Color(0xFF190620),
        body:
            orientation == Orientation.landscape ? _landscape() : _portrait());
  }
}

class FlyingShips extends StatefulWidget {
  @override
  _FlyingShipsState createState() => _FlyingShipsState();
}

class _FlyingShipsState extends State<FlyingShips> {
  Artboard? _riveArtboard;
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/ships.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? const SizedBox()
        : Rive(
            artboard: _riveArtboard!,
          );
  }
}
