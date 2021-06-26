import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '/models/ruler_model.dart';
import '/screens/game_screen.dart';
import '/services/game.dart';
import '/utility/constants.dart';
import '/utility/utility.dart';
import '/widgets/static_stars_bg.dart';

class CharacterSelectionScreen extends StatelessWidget {
  static const route = '/character-selection-screen';

  Widget get _animatedStars {
    return Lottie.asset('assets/animations/stars.json');
  }

  Widget get _spaceLights {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            opacityBlack(0.3),
            opacityIndigo(0.4),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget _heading() {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Text('Choose Character',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontFamily: 'Italianno')),
        ),
      );
    }

    Widget _description(Ruler ruler) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(16.sp)),
        child: SingleChildScrollView(
          child: Text(
            kRulerDescriptionData[ruler]!,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    Widget _continue(Ruler ruler) {
      return SizedBox(
        width: 360,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF120530))),
            onPressed: () {
              Provider.of<Game>(context, listen: false).initGame(ruler);
              Navigator.pushReplacementNamed(context, GameScreen.route);
            },
            child: const Text('Continue'),
          ),
        ),
      );
    }

    Widget _rulerImage(Ruler ruler, int flex) {
      return Expanded(
        flex: flex,
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          radius: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Image.asset(
              'assets/img/ruler/${describeEnum(ruler)}.png',
            ),
          ),
        ),
      );
    }

    Widget _rulerName(Ruler ruler, int flex) {
      return Expanded(
        flex: flex,
        child: Container(
          alignment: flex == 1 ? Alignment.center : Alignment.centerRight,
          child: Text(describeEnum(ruler).inCaps,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      );
    }

    Widget _characterCard(Ruler ruler, Orientation orientation) {
      return Container(
        padding: EdgeInsets.all(16.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(16.sp)),
        child: orientation == Orientation.landscape
            ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [_rulerImage(ruler, 2), _rulerName(ruler, 1)],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(child: _description(ruler)),
                        _continue(ruler),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [_rulerImage(ruler, 1), _rulerName(ruler, 2)],
                    ),
                  ),
                  Expanded(flex: 2, child: _description(ruler)),
                  _continue(ruler),
                ],
              ),
      );
    }

    Widget _characterMenu(Orientation orientation) {
      return Align(
        alignment: orientation == Orientation.landscape
            ? Alignment.bottomCenter
            : Alignment.center,
        child: CarouselSlider.builder(
          options: CarouselOptions(
            aspectRatio: orientation == Orientation.landscape ? 2.4 : 0.8,
          ),
          itemCount: kRulerDescriptionData.length,
          itemBuilder: (BuildContext context, int index, _) => _characterCard(
              List<Ruler>.from(kRulerDescriptionData.keys)[index], orientation),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _animatedStars,
          _spaceLights,
          _heading(),
          OrientationBuilder(
            builder: (context, orientation) {
              return _characterMenu(orientation);
            },
          ),
        ],
      ),
    );
  }
}
