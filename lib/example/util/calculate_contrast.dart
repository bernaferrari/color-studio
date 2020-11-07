import 'dart:math';

import 'package:flutter/material.dart';

double calculateContrast(Color color1, Color color2) {
  final double colorFirstLum = color1.computeLuminance();
  final double colorSecondLum = color2.computeLuminance();

  final double l1 = min(colorFirstLum, colorSecondLum);
  final double l2 = max(colorFirstLum, colorSecondLum);

  return 1 / ((l1 + 0.05) / (l2 + 0.05));
}
