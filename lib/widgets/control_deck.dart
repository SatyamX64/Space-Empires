import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ControlDeckItem {
  ControlDeckItem({this.iconData, this.text}) {
    assert(text != null);
  }
  IconData iconData;
  String text;
}

class ControlDeck extends StatefulWidget {
  ControlDeck({
    this.items,
    this.showText: true,
    this.centerItemText,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onPressed,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<ControlDeckItem> items;
  final bool showText;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onPressed;

  @override
  State<StatefulWidget> createState() => ControlDeckState();
}

class ControlDeckState extends State<ControlDeck> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onPressed(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black.withOpacity(0.5), Colors.indigo.withOpacity(0.5)]),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(String text) {
    return SvgPicture.asset(
      'assets/img/control_deck/${text.toLowerCase()}.svg',
      height: widget.iconSize,
      width: widget.iconSize,
    );
  }

  Widget _buildTabItem({
    ControlDeckItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                item.iconData == null
                    ? _image(item.text)
                    : Icon(item.iconData, color: color, size: widget.iconSize),
                widget.showText
                    ? Text(
                        item.text,
                        style: TextStyle(color: color),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
