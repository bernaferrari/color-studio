import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpendingCategoryChartPainter extends CustomPainter {
  const SpendingCategoryChartPainter({
    this.percent,
    this.color,
    this.circleColor,
    this.backgroundColor,
  });

  final double percent;
  final Color color;
  final Color circleColor;
  final Color backgroundColor;

  @override
  void paint(canvas, size) {
    final paint = Paint();
    paint.color = backgroundColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 7;
    paint.strokeCap = StrokeCap.square;

    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, math.pi * 2,
        false, paint);
    paint.color = color;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      -2 * math.pi * percent,
      false,
      paint,
    );

    if (circleColor != null) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2 - 3,
        Paint()..color = circleColor,
      );
    }
  }

  @override
  bool shouldRepaint(SpendingCategoryChartPainter oldDelegate) {
    return percent != oldDelegate.percent || color != oldDelegate.color;
  }
}
