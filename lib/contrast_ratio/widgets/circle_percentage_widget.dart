import 'package:colorstudio/contrast_ratio/widgets/scaling_info.dart';
import 'package:colorstudio/example/contrast/contrast_util.dart';
import 'package:colorstudio/example/mdc/contrast_compare.dart';
import 'package:flutter/material.dart';

import 'circle_percentage_painter.dart';

class CirclePercentageWidget extends StatefulWidget {
  const CirclePercentageWidget({
    this.title = "",
    this.subtitle = "",
    this.percent = 0.0,
    this.contrastValue = 0.0,
    this.color = Colors.white,
  });

  final String title;
  final String subtitle;
  final double percent;
  final double contrastValue;
  final Color color;

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
      duration: Duration(milliseconds: 1200),
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
        Text(widget.title),
        Text(widget.subtitle),
        Container(
          width: 48 * ScalingInfo.scaleY,
          height: 48 * ScalingInfo.scaleY,
          margin: EdgeInsets.symmetric(vertical: 16),
          child: CustomPaint(
            isComplex: false,
            painter: SpendingCategoryChartPainter(
              _controller.value,
              widget.color,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ContrastText(widget.contrastValue),
                  Text(
                    getContrastLetters(widget.contrastValue),
                    style: Theme.of(context).textTheme.overline,
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
