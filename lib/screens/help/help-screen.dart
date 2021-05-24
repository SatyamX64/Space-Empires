import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:some_game/screens/help/instructions-screen.dart';
import 'package:some_game/utility/constants.dart';
import 'package:some_game/utility/ripple_page_transition.dart';
import 'package:sizer/sizer.dart';

class HelpScreen extends StatefulWidget {
  static const route = '/help-screen';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final GlobalKey _fabButtonKey = GlobalKey();
  RipplePageTransition _ripplePageTransition;

  static const _FabButtonColor = kMaroon;

  @override
  void initState() {
    _ripplePageTransition = RipplePageTransition(_fabButtonKey);
    super.initState();
  }

  List<String> _dialogueList = [
    '*As you slowly fall into sleep*',
    '*The Strange figure appears*',
    'Yo',
    'Here again huh',
    'So what do you wanna know ?',
  ];

  _dialogue() {
    return Center(
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
        onFinished: () => _ripplePageTransition.navigateTo(InstructionScreen()),
      ),
    );
  }

  Widget _portrait() {
    return Column(
      children: [
        Expanded(flex: 3, child: _Stym()),
        Expanded(child: _dialogue()),
      ],
    );
  }

  Widget _landscape() {
    return Row(
      children: [
        Expanded(
          child: _Stym(),
        ),
        Expanded(
            child: Center(
          child: _dialogue(),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Center(
                child: TextButton(
                  child: Text(
                    'Wake up',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
          backgroundColor: Color(0xFF190620),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: MediaQuery.of(context).orientation == Orientation.landscape
              ? _landscape()
              : _portrait(),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _floatingActionButton,
          ),
        ),
        _ripplePageTransition,
      ]);

  Widget get _floatingActionButton => FloatingActionButton(
        key: _fabButtonKey,
        backgroundColor: _FabButtonColor,
        child: Icon(CupertinoIcons.search, size: 32.sp, color: Colors.white70),
        elevation: 2.0,
        onPressed: () => _ripplePageTransition.navigateTo(InstructionScreen()),
      );
}

class _Stym extends StatefulWidget {
  @override
  _StymState createState() => _StymState();
}

class _StymState extends State<_Stym> {
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
