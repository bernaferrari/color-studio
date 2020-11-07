import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'hsinter.dart';
import 'util/color_util.dart';

extension ListConversion<T> on List<Color> {
  List<ColorWithInter> convertToInter(HSInterType kind) =>
      map((c) => ColorWithInter(c, HSInterColor.fromColor(c, kind))).toList();
}

extension ListConversionInter<T> on List<HSInterColor> {
  List<ColorWithInter> convertToColorWithInter() =>
      map((c) => ColorWithInter(c.toColor(), c)).toList();
}

class ColorWithInter {
  ColorWithInter(this.color, this.inter)
      : lum = color.computeLuminance(),
        colorHex = color.toHexStr();

  final Color color;
  final HSInterColor inter;
  final String colorHex;
  final double lum;
}
