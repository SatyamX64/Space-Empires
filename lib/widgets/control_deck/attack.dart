import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

showAttackMenu(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.size,
      barrierDismissible: true,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: size.height * 0.6,
              width: size.width * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.indigo.withOpacity(0.8)
                ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Attack',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black26,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          'assets/img/planets/arth.png')),
                                  Expanded(
                                      child: Image.asset(
                                          'assets/img/planets/eno.png')),
                                  Expanded(
                                      child: Image.asset(
                                          'assets/img/planets/miavis.png'))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          'assets/img/planets/musk.png')),
                                  Expanded(
                                      child: Image.asset(
                                          'assets/img/planets/ocorix.png')),
                                  Expanded(
                                      child: Image.asset(
                                          'assets/img/planets/jupinot.png'))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Your Forces',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      // color: Colors.red,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.indigoAccent),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  // radius: double.maxFinite,
                                  backgroundColor: Colors.black12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                        'assets/img/ships/attack/astro.svg'),
                                  ),
                                ),
                              ),
                              Text('45',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                            ],
                          )),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigoAccent),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: double.maxFinite,
                              backgroundColor: Colors.black12,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    'assets/img/ships/attack/magnum.svg'),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigoAccent),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: double.maxFinite,
                              backgroundColor: Colors.black12,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    'assets/img/ships/attack/rover.svg'),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

class _UpgradeDialogStatsBox extends StatelessWidget {
  const _UpgradeDialogStatsBox({Key key, this.header, this.value})
      : super(key: key);

  final String header;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            Text(header),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
