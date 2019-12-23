import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpendingCategoryChartPainter extends CustomPainter {
  final double percent;
  final Color color;

  SpendingCategoryChartPainter(this.percent, this.color);

  @override
  void paint(canvas, size) {
    final paint = Paint();
    paint.color = Color(0xFF5B668C);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 7;
    paint.strokeCap = StrokeCap.square;

    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, math.pi * 2,
        false, paint);
    paint.color = color;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -math.pi / 2,
        -2 * math.pi * percent, false, paint);
  }

  @override
  bool shouldRepaint(SpendingCategoryChartPainter oldCategory) {
    return percent != oldCategory.percent || color != oldCategory.color;
  }
}
