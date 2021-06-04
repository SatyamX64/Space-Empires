import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:some_game/screens/welcome_screen.dart';
import 'package:some_game/utility/utility.dart';
import 'package:some_game/utility/constants.dart';

import 'story_ii.dart';

class StoryScreenI extends StatefulWidget {
  static const route = '/story-i-screen.dart';
  // The Screen works well in both orientation
  // But if orientation changes b/w animation than it resets
  // To avoid this potentially unwanted behaviour we lock the Screen to the orientation we entered with
  // and reset is back to normal after we leave the story section
  final Orientation orientation;
  StoryScreenI(this.orientation);
  @override
  _StoryScreenIState createState() => _StoryScreenIState();
}

class _StoryScreenIState extends State<StoryScreenI> {
  double _proceedButtonOpactity = 0.0;

  @override
  void initState() {
    super.initState();
    Utility.lockOrientation(orientation: widget.orientation);
  }

  List<String> _dialogueList = const [
    'Oh Hi there, your highness..',
    'Now I am sure none of this makes sense',
    'It Probably never will',
    'and I am sure you have some doubts',
    'The obvious one being where are we',
    'and who the hell am I ?',
    'So let\'s get a formal Introduction shall we ?',
    'I am STYM, from the space patrol',
    'and at the moment we are in your Dream',
    'So considering YOU are the ruler of one of the 4 Major Races',
    'I have come to inform you that',
    'The Solar System is going to collapse',
    '365 days from now',
    'Now I know this is quite shocking..obviously',
    'and you must be confused',
    'But Save that for later, because',
    'I have a Plan',
    '*The Strange Figure Vanishes*',
  ];

  _skipButton() {
    return Positioned(
      child: AnimatedOpacity(
        child: TextButton(
            onPressed: () {
              Utility.lockOrientation(); // resets orientation to normal
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
      right: 16.sp, // sp is relative size given to us by Sizer class
      bottom: 16.sp,
    );
  }

  _proceedButton() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(StoryScreenII.route);
        },
        child: Container(
            height: 40.sp,
            width: 160.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Palette.maroon,
                borderRadius: BorderRadius.circular(50.sp)),
            child: Text(
              'Hear his Plan',
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
              child: _Astronaut(),
              duration: Duration(seconds: 2),
              opacity: 1 - _proceedButtonOpactity,
            ),
          ),
          _dialogue(Orientation.portrait),
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

    Widget _landscape() {
      return Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedOpacity(
                  child: _Astronaut(),
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

    return Scaffold(
        backgroundColor: Color(0xFF200520),
        body: widget.orientation == Orientation.landscape
            ? _landscape()
            : _portrait());
  }
}

class _Astronaut extends StatefulWidget {
  @override
  _AstronautState createState() => _AstronautState();
}

class _AstronautState extends State<_Astronaut> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/stym.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('idle'));
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
