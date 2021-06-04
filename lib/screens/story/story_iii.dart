import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/utility.dart';
import '../welcome_screen.dart';

class StoryScreenIII extends StatefulWidget {
  static const route = '/story-iii-screen.dart';
  @override
  _StoryScreenIIIState createState() => _StoryScreenIIIState();
}

class _StoryScreenIIIState extends State<StoryScreenIII> {
  double _proceedButtonOpactity = 0.0;

  @override
  dispose() {
    Utility.lockOrientation(); // unlocks rotation
    super.dispose();
  }

  List<String> _dialogueList = const [
    'To make sure only you get the Crystal',
    'You must take over all Planets',
    'According to rumours...',
    'The 3 other rulers saw the dream as well',
    'So they will try the same',
    'So get ready..',
    'Because your adventure has begun',
  ];

  _skipButton() {
    return Positioned(
      child: AnimatedOpacity(
        child: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(WelcomeScreen.route);
            },
            child: Text(
              'Skip',
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
            )),
        duration: Duration(seconds: 2),
        opacity: 1 - _proceedButtonOpactity,
      ),
      right: 16.sp,
      bottom: 16.sp,
    );
  }

  _proceedButton() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(WelcomeScreen.route);
        },
        child: Container(
            height: 40.sp,
            width: 160.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Palette.maroon,
                borderRadius: BorderRadius.circular(50.sp)),
            child: Text(
              'I am ready',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
      ),
    );
  }

  _dialogue(Orientation orientation) {
    return Container(
      alignment: orientation == Orientation.landscape
          ? Alignment.center
          : Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 72.sp),
      child: AnimatedTextKit(
        animatedTexts: List.generate(
            _dialogueList.length,
            (index) => FadeAnimatedText(_dialogueList[index],
                textStyle: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center)),
        totalRepeatCount: 0,
        isRepeatingAnimation: false,
        pause: const Duration(milliseconds: 1000),
        displayFullTextOnTap: false,
        stopPauseOnTap: false,
        onFinished: () {
          setState(() {
            _proceedButtonOpactity = 1.0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _portrait() {
      return Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              child: _Planets(),
              duration: Duration(seconds: 2),
              opacity: 1 - _proceedButtonOpactity,
            ),
          ),
          _dialogue(Orientation.portrait),
          Align(
            child: AnimatedOpacity(
              child: _proceedButton(),
              duration: Duration(seconds: 2),
              opacity: _proceedButtonOpactity,
            ),
            alignment: Alignment.center,
          ),
          _skipButton(),
        ],
      );
    }

    Widget _landscape() {
      return Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedOpacity(
                  child: _Planets(),
                  duration: Duration(seconds: 2),
                  opacity: 1 - _proceedButtonOpactity,
                ),
              ),
              Expanded(child: _dialogue(Orientation.landscape)),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              child: _proceedButton(),
              duration: Duration(seconds: 2),
              opacity: _proceedButtonOpactity,
            ),
          ),
          _skipButton(),
        ],
      );
    }

    final Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Color(0xFF170C1E),
            body: orientation == Orientation.landscape
                ? _landscape()
                : _portrait()),
        onWillPop: () {
          Utility.lockOrientation(); // resets orientation to normal
          return Future.value(true);
        });
  }
}

class _Planets extends StatefulWidget {
  @override
  __PlanetsState createState() => __PlanetsState();
}

class __PlanetsState extends State<_Planets> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/planet.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('Idle'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? const SizedBox()
        : Rive(
            artboard: _riveArtboard,
          );
  }
}
