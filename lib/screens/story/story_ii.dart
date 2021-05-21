import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/utility.dart';

import '../welcome_screen.dart';
import 'story_iii.dart';


class StoryScreenII extends StatefulWidget {
  static const route = '/story-ii-screen.dart';
  @override
  _StoryScreenIIState createState() => _StoryScreenIIState();
}

class _StoryScreenIIState extends State<StoryScreenII> {
  double _proceedButtonOpactity = 0.0;

  @override
  dispose() {
    super.dispose();
  }

  List<String> _dialogueList = const [
    'The only way to stop the doom',
    'Is the paradox Jewel ',
    'The Jewel carries the power..',
    'to restore the balance once again',
    'Now YOU must find it',
    'The Jewel only reveals iteself',
    'When all 8 Planets are sync',
    'So O mighty ruler, please take command',
    'and bring all 8 Planets under your Empire',
    'for this is the time to ascend',
    '* The Strange figure vanishes *'
  ];

  _skipButton() {
    return Positioned(
      child: AnimatedOpacity(
        child: TextButton(
            onPressed: () {
              Utility.lockOrientation();
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
          Navigator.of(context).pushReplacementNamed(StoryScreenIII.route);
        },
        child: Container(
            height: 40.sp,
            width: 160.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: kMaroon,
                borderRadius: BorderRadius.circular(50.sp)),
            child: Text(
              'Continue',
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
              child: _ParadoxCrystal(),
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
            alignment: Alignment.bottomCenter,
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
                  child: _ParadoxCrystal(),
                  duration: Duration(seconds: 2),
                  opacity: 1 - _proceedButtonOpactity,
                ),
              ),
              Expanded(child: _dialogue(Orientation.landscape)),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: AnimatedOpacity(
                child: _proceedButton(),
                duration: Duration(seconds: 2),
                opacity: _proceedButtonOpactity,
              ),
            ),
          ),
          _skipButton(),
        ],
      );
    }

    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: Color(0xFF190620),
        body:
            orientation == Orientation.landscape ? _landscape() : _portrait());
  }
}

class _ParadoxCrystal extends StatefulWidget {
  @override
  __ParadoxCrystalState createState() => __ParadoxCrystalState();
}

class __ParadoxCrystalState extends State<_ParadoxCrystal> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/paradox.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('in'));
        setState(() => _riveArtboard = artboard);
      },
    );
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _controller.isActive = false;
      });
    });
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
