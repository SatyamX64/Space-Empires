import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utility/constants.dart';

class ControlDeckItem {
  ControlDeckItem({required this.text, this.isPng = false});

  String text;
  bool isPng;
}

// Bottom App Bar
// child Priority if clash happens : svg > png

class ControlDeck extends StatefulWidget {
  const ControlDeck({
    required this.items,
    this.showLabel = true,
    this.height = 60.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.labelColor = Colors.white,
    this.notchedShape,
    required this.onPressed,
  }) : assert(items.length == 2 || items.length == 4);

  final List<ControlDeckItem> items;
  final bool showLabel;
  final double height;
  final double iconSize;
  final Color labelColor;
  final Color? backgroundColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int?> onPressed;

  @override
  State<StatefulWidget> createState() => ControlDeckState();
}

class ControlDeckState extends State<ControlDeck> {
  void _updateIndex(int? index) {
    widget.onPressed(index);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_final_locals
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [opacityBlack(0.5), opacityIndigo(0.5)]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
      ),
    );
  }

  Widget _image(String text, bool isPng) {
    if (isPng) {
      return Image.asset(
        'assets/img/control_deck/${text.toLowerCase()}.png',
        height: widget.iconSize,
        width: widget.iconSize,
      );
    }
    return SvgPicture.asset(
      'assets/img/control_deck/${text.toLowerCase()}.svg',
      height: widget.iconSize,
      width: widget.iconSize,
    );
  }

  Widget _buildTabItem({
    ControlDeckItem? item,
    int? index,
    ValueChanged<int?>? onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed!(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.showLabel == false) _image(item!.text, item.isPng),
                if (widget.showLabel)
                  Text(
                    item!.text,
                    style: TextStyle(
                      color: widget.labelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
