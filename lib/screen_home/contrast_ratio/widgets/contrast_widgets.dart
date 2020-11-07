import 'package:flutter/material.dart';

import 'circle_percentage_widget.dart';

class ContrastCircleBar extends StatelessWidget {
  const ContrastCircleBar({
    this.contrast = 0.5,
    this.title = "",
    this.subtitle = "",
    this.animateOnInit = true,
    this.circleColor,
    this.contrastingColor,
  });

  final double contrast;
  final String title;
  final String subtitle;
  final bool animateOnInit;
  final Color circleColor;
  final Color contrastingColor;

  @override
  Widget build(BuildContext context) {
    // if contrast gets too low, it becomes too hard to read, therefore, better become white.
//    final contrasting = (contrast > 2) ? contrastingColor : Theme.of(context).colorScheme.onSurface;

    return CirclePercentageWidget(
      title: title,
      subtitle: subtitle,
      percent: getNormalised(contrast) / 100,
      contrastValue: contrast,
      color: getProgressColor(contrast),
      animatedInit: animateOnInit,
      circleColor: (contrast > 2) ? circleColor : null,
      contrastingColor: (contrast > 2) ? contrastingColor : null,
    );
  }

  Color getProgressColor(double contrast) {
    if (contrast < 3.0) {
      return Colors.redAccent[200];
    } else if (contrast < 4.5) {
      return Colors.orangeAccent[200];
    } else if (contrast < 7) {
      return Colors.lightGreen[200];
    } else {
      return Colors.greenAccent[200];
    }
  }

  double getNormalised(double contrast) {
    double normalized;

    if (contrast < 7) {
      normalized = (contrast - 1.0) / (7 - 1.0) * 100 * 0.75;
    } else {
      normalized = 75 + (contrast - 7) / (21.0 - 7) * 100 * 0.25;
    }

    return normalized;
  }
}
