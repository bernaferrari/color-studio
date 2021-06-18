import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalProgressBar extends StatelessWidget {
  const HorizontalProgressBar({
    Key? key,
    this.currentValue = 0,
    this.maxValue = 100,
    this.size = 30,
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
    this.borderRadius = 8,
    this.borderColor = const Color(0xFFFA7268),
    this.borderWidth = 0.2,
    this.backgroundColor = const Color(0x00FFFFFF),
    this.progressColor = const Color(0xFFFA7268),
    this.changeProgressColor = const Color(0xFF5F4B8B),
  }) : super(key: key);

  final int currentValue;
  final int maxValue;
  final double size;
  final Axis direction;
  final VerticalDirection verticalDirection;
  final double borderRadius;
  final Color backgroundColor;
  final Color progressColor;
  final Color changeProgressColor;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final double position = currentValue / maxValue;

    final Widget progressWidget = Container(
      decoration: BoxDecoration(
        color: progressColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    // https://github.com/flutter/flutter/issues/14421
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: direction == Axis.vertical ? size : null,
        height: direction == Axis.horizontal ? size : null,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderWidth == 0
              ? null
              : Border.all(color: borderColor, width: borderWidth),
        ),
        child: Stack(
          children: <Widget>[
            Flex(
              direction: direction,
              verticalDirection: verticalDirection,
              children: <Widget>[
                Expanded(
                  flex: (position * 100).toInt(),
                  child: progressWidget,
                ),
                Expanded(
                    flex: 100 - (position * 100).toInt(), child: Container())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RectangularPercentageWidget extends StatefulWidget {
  const RectangularPercentageWidget({
    Key? key,
    this.percent = 0.0,
    this.size = 30,
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
    this.borderRadius = 4,
    this.borderColor = const Color(0xFFFA7268),
    this.borderWidth = 0.2,
    this.backgroundColor = const Color(0x00FFFFFF),
    this.progressColor = const Color(0xFFFA7268),
  }) : super(key: key);

  final double percent;
  final double size;
  final Axis direction;
  final VerticalDirection verticalDirection;
  final double borderRadius;
  final Color backgroundColor;
  final Color? progressColor;
  final Color borderColor;
  final double borderWidth;

  @override
  State createState() => _RectangularPercentageWidgetState();
}

class _RectangularPercentageWidgetState
    extends State<RectangularPercentageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.animateTo(widget.percent);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RectangularPercentageWidget oldWidget) {
    if (oldWidget.percent != widget.percent) {
      _controller.animateTo(widget.percent);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final double position = _controller.value;

    final Widget progressWidget = Container(
      decoration: BoxDecoration(
        color: widget.progressColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.borderRadius),
        ),
      ),
    );

    // https://github.com/flutter/flutter/issues/14421
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.direction == Axis.vertical ? widget.size : null,
        height: widget.direction == Axis.horizontal ? widget.size : null,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: widget.borderWidth == 0
              ? null
              : Border.all(
                  color: widget.borderColor,
                  width: widget.borderWidth,
                ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              left: 0,
              bottom: 75,
              // 7.0:1 normalized
              child: Container(
                height: 1,
                color: Colors.grey.withOpacity(0.30),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 43,
              // 4.5:1 normalized
              child: Container(
                height: 1,
                color: Colors.grey.withOpacity(0.30),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 25,
              // 3.0:1 normalized
              child: Container(
                height: 1,
                color: Colors.grey.withOpacity(0.30),
              ),
            ),
            Flex(
              direction: widget.direction,
              verticalDirection: widget.verticalDirection,
              children: <Widget>[
                Expanded(
                  flex: (position * 100).toInt(),
                  child: progressWidget,
                ),
                Expanded(
                  flex: 100 - (position * 100).toInt(),
                  child: Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
