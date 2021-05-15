import 'package:flutter/material.dart';
import 'package:some_game/widgets/gradient_dialog.dart';

showStatsMenu(BuildContext context) {
  return showGradientDialog(
      context: context,
      child: Column(
        children: [
          Text(
            'Stats',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          _ResourceAllocator(),
          _RivalsOpinion()
        ],
      ));
}

class _ResourceAllocator extends StatelessWidget {
  _ResourceAllocator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black12,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _InfoBar(text: 'Propoganda', value: _PlusMinus()),
                      _InfoBar(text: 'Luxury', value: _PlusMinus()),
                      _InfoBar(text: 'Culture', value: _PlusMinus()),
                      _InfoBar(text: 'Military', value: _PlusMinus()),
                    ],
                  ),
                ),
              ),
              _InfoBar(
                  text: 'Total',
                  value: Text(
                    '12324 AP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ));
  }
}

class _RivalsOpinion extends StatelessWidget {
  _RivalsOpinion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
      child: SingleChildScrollView(
        child:
            Text('The Aliens choose to ignore us\nHave better things at hand',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontFamily: 'Italianno',
                    )),
      ),
    ));
  }
}

class _InfoBar extends StatelessWidget {
  _InfoBar({this.text, this.value});
  _statsText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  final text;
  final value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            child: _statsText(text),
          )),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: value,
          )),
        ],
      ),
    );
  }
}

class _PlusMinus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(4),
            child: Text(
              '243',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove),
            ),
          ),
        ],
      ),
    );
  }
}
