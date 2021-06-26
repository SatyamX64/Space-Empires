import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/game.dart';
import '/widgets/gradient_dialog.dart';

Future<void> showGlobalNews(BuildContext context) {
  final List<String> news =
      Provider.of<Game>(context, listen: false).galacticNews;
  return showGradientDialog(
    context: context,
    child: Column(
      children: [
        Text(
          '༺ Global News ༻',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontFamily: 'Italianno', fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
          child: Center(
              child: Divider(
            color: Colors.white70,
          )),
        ),
        Expanded(
          child: ListView.separated(
              itemBuilder: (_, index) {
                return ListTile(
                  dense: true,
                  title: Text(
                    news[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                );
              },
              separatorBuilder: (_, __) {
                return const Divider(
                  thickness: 1,
                );
              },
              itemCount: news.length),
        ),
      ],
    ),
  );
}
