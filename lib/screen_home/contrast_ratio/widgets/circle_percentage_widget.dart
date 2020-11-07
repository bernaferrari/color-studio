import 'package:colorstudio/example/mdc/contrast_compare.dart';
import 'package:flutter/material.dart';

import '../../../contrast_util.dart';
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
  });

  final String title;
  final String subtitle;
  final double percent;
  final double contrastValue;
  final Color color;
  final Color circleColor;
  final Color contrastingColor;
  final bool animatedInit;

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
  Widget build(context) {



    return Column(
      children: [
        Text(
          "${widget.title} x",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
        ),
        Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        Container(
          width: 80,
          height: 80,
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
