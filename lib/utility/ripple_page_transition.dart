import 'package:flutter/material.dart';
import 'package:some_game/utility/constants.dart';

class RipplePageTransition extends StatefulWidget {
  RipplePageTransition(
    this._originalWidgetKey, {
    Color color,
  }) : color = color ?? kMaroon;

  final GlobalKey _originalWidgetKey;
  final Color color;
  final _state = _RipplePageTransitionState();

  void navigateTo(Widget page) => _state.startSpreadOutAnimation(page);

  @override
  _RipplePageTransitionState createState() => _state;
}

class _RipplePageTransitionState extends State<RipplePageTransition> {
  Widget _page;
  Rect _originalWidgetRect;
  Rect _ripplePageTransitionRect;

  // Starts ripple effect from the original widget size to the whole screen.
  void startSpreadOutAnimation(Widget page) {
    if (!mounted) {
      return;
    }

    setState(() {
      _page = page;
      _originalWidgetRect = _getWidgetRect(widget._originalWidgetKey);
      _ripplePageTransitionRect = _originalWidgetRect;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final fullscreenSize = 1.3 * MediaQuery.of(context).size.longestSide;
      // Expands the `_ripplePageTransitionRect` to cover the whole screen.
      setState(() {
        return _ripplePageTransitionRect =
            _ripplePageTransitionRect.inflate(fullscreenSize);
      });
    });
  }

  // Starts ripple effect from the whole screen to the original widget size.
  void _startShrinkInAnimation() =>
      setState(() => _ripplePageTransitionRect = _originalWidgetRect);

  Rect _getWidgetRect(GlobalKey globalKey) {
    var renderObject = globalKey?.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    var size = renderObject?.semanticBounds?.size;

    if (translation != null && size != null) {
      return new Rect.fromLTWH(
          translation.x, translation.y, size.width, size.height);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ripplePageTransitionRect == null) {
      return Container();
    }

    return AnimatedPositioned.fromRect(
      rect: _ripplePageTransitionRect,
      duration: Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
      onEnd: () {
        bool shouldNavigatePage =
            _ripplePageTransitionRect != _originalWidgetRect;
        if (shouldNavigatePage) {
          Navigator.push(
            context,
            FadeRouteBuilder(page: _page),
          ).then((_) {
            _startShrinkInAnimation();
          });
        } else {
          if (!mounted) {
            return;
          }

          // Dismiss ripple widget after shrinking finishes.
          setState(() => _ripplePageTransitionRect = null);
        }
      },
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  FadeRouteBuilder({@required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) =>
              FadeTransition(opacity: animation, child: child),
        );
}
