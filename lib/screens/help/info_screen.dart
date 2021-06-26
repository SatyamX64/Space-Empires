import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:space_empires/screens/character_selection_screen.dart';
import 'package:space_empires/utility/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:space_empires/utility/instructions.dart';
import 'package:space_empires/widgets/static_stars_bg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future launchURL(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class InfoScreen extends StatelessWidget {
  InfoScreen({Key? key, required this.characterSelected}) : super(key: key);

  static const route = '/info-screen';
  final bool characterSelected;
  final InAppReview inAppReview = InAppReview.instance;

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
    final _gameTitle = Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image(
            image: const AssetImage('assets/img/icon.png'),
            height: 32.sp,
            width: 32.sp,
          ),
        ),
        Expanded(
          child: Text(
            'Space Empires',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    final _links = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () async {
              try {
                await launchURL(githubLink);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            icon: const Icon(FontAwesomeIcons.github)),
        IconButton(
            onPressed: () async {
              try {
                await inAppReview.openStoreListing();
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            icon: const Icon(
              Icons.star,
              color: Colors.yellow,
            )),
        IconButton(
            onPressed: () async {
              try {
                await launchURL(portfolioLink);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            icon: const Icon(
              FontAwesomeIcons.addressCard,
            )),
      ],
    );
    final _proceedButton = Visibility(
        visible: !characterSelected,
        child: Center(
          child: SizedBox(
            width: 360.sp,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: const Color(0xFF814FC1)),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, CharacterSelectionScreen.route);
              },
              child: const Text('Proceed'),
            ),
          ),
        ));
    final _heading = Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Instructions',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontFamily: 'Italianno')),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back_ios)),
            )
          ],
        ),
      ),
    );

    Widget _welcomeCard(orientation) {
      return Container(
        padding: EdgeInsets.all(16.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(16.sp)),
        child: Column(
            children: orientation == Orientation.landscape
                ? [
                    Row(
                      children: [
                        Expanded(child: _gameTitle),
                        Expanded(child: _links),
                      ],
                    ),
                    SizedBox(
                      height: 16.sp,
                      child: const Divider(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• A Space Themed Strategy game made in Flutter\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                            ),
                            Text(
                              '• The Game is in Development and open-souce',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 8.sp,
                              child: const Divider(),
                            ),
                            _proceedButton
                          ],
                        ),
                      ),
                    )
                  ]
                : [
                    _gameTitle,
                    SizedBox(
                      height: 16.sp,
                      child: const Divider(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• A Space Themed Strategy game made in Flutter\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                            ),
                            Text(
                              '• The Game is in Development and open-souce',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 8.sp,
                              child: const Divider(),
                            ),
                            _links,
                            SizedBox(
                              height: 8.sp,
                              child: const Divider(),
                            ),
                            _proceedButton,
                          ],
                        ),
                      ),
                    )
                  ]),
      );
    }

    Widget _instructionCard(String instruction) {
      return Container(
        padding: EdgeInsets.all(16.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(16.sp)),
        child: Column(
          children: [
            Text(
              instruction,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16.sp,
              child: const Divider(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  kInstructionsData[instruction]!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _instructionMenu(Orientation orientation) {
      return Align(
        alignment: orientation == Orientation.landscape
            ? Alignment.bottomCenter
            : Alignment.center,
        child: CarouselSlider.builder(
            options: CarouselOptions(
              aspectRatio: orientation == Orientation.landscape ? 2.4 : 0.8,
            ),
            itemCount: kInstructionsData.length + 1,
            itemBuilder: (BuildContext context, int index, _) {
              if (index == 0) {
                return _welcomeCard(orientation);
              } else {
                return _instructionCard(
                    List<String>.from(kInstructionsData.keys)[index - 1]);
              }
            }),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          StaticStarsBackGround(),
          _animatedStars,
          _spaceLights,
          _heading,
          OrientationBuilder(
            builder: (context, orientation) {
              return _instructionMenu(orientation);
            },
          ),
        ],
      ),
    );
  }
}
