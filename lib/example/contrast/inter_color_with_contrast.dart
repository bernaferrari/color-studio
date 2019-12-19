import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/util/color_util.dart';

extension ListConversion<T> on List<Color> {
  List<InterColorWithContrast> convertToInterContrast(String kind, Color otherColor) =>
      map((Color c) => InterColorWithContrast(
            c,
            HSInterColor.fromColor(c, kind),
            otherColor,
          )).toList();
}

class InterColorWithContrast {
  InterColorWithContrast(this.color, this.inter, Color otherColor)
      : lum = color.computeLuminance(),
        contrast = calculateContrast(color, otherColor),
        colorHex = color.toHexStr();

  final Color color;
  final HSInterColor inter;
  final double contrast;
  final String colorHex;
  final double lum;
}

double calculateContrast(Color color1, Color color2) {
  final double colorFirstLum = color1.computeLuminance();
  final double colorSecondLum = color2.computeLuminance();

  final double l1 = min(colorFirstLum, colorSecondLum);
  final double l2 = max(colorFirstLum, colorSecondLum);

  return 1 / ((l1 + 0.05) / (l2 + 0.05));
}
