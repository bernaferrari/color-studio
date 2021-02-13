import 'package:flutter/material.dart';

import '../../../contrast_util.dart';
import '../../../example/mdc/contrast_compare.dart';
import 'circle_percentage_painter.dart';

class CirclePercentageWidget extends StatefulWidget {
  const CirclePercentageWidget({
    this.title = "",
    this.subtitle = "",
    this.percent = 0.0,
    this.contrastValue = 0.0,
    this.color = Colors.white,
    this.circleColor,
    this.contrastingColor,
    this.animatedInit = true,
    this.sizeCondition,
  });

  final String title;
  final String subtitle;
  final double percent;
  final double contrastValue;
  final Color color;
  final Color circleColor;
  final Color contrastingColor;
  final bool animatedInit;
  final bool sizeCondition;

  @override
  State createState() => _CirclePercentageWidgetState();
}

class _CirclePercentageWidgetState extends State<CirclePercentageWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller.addListener(() {
      setState(() {});
    });

    if (widget.animatedInit) {
      _controller.animateTo(widget.percent);
    } else {
      _controller.value = widget.percent;
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CirclePercentageWidget oldWidget) {
    if (oldWidget.percent != widget.percent) {
      _controller.animateTo(widget.percent);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isLargeSize = MediaQuery.of(context).size.width > 850;

    return Flex(
      direction: widget.sizeCondition ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${widget.title} x",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: isLargeSize ? 16 : 14,
                      fontWeight: FontWeight.w200,
                    ),
              ),
              Text(
                widget.subtitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: isLargeSize ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              // write the longest possible string, so that the circles don't keep alternating the size.
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
                child: SizedBox(
                  height: 0,
                  child: Text(
                    "Background x",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: isLargeSize ? 16 : 14,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: isLargeSize ? 100 : 80,
          height: isLargeSize ? 100 : 80,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: CustomPaint(
            isComplex: false,
            painter: CirclePercentagePainter(
              percent: _controller.value,
              color: widget.color,
              circleColor: widget.circleColor,
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  SizedBox(height: 8),
//                  Text(
//                    "test",
//                    style: Theme.of(context).textTheme.overline.copyWith(
//                      color: widget.contrastingColor
//                    ),
//                  ),
                  ContrastText(
                    widget.contrastValue,
                    color: widget.contrastingColor,
                  ),
                  Text(
                    getContrastLetters(widget.contrastValue),
                    style: Theme.of(context).textTheme.overline.copyWith(
                          color: widget.contrastingColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
