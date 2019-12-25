import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ListConversion<T> on List<Color> {
  List<ColorWithInter> convertToInter(String kind) =>
      map((Color c) => ColorWithInter(c, HSInterColor.fromColor(c, kind)))
          .toList();
}

extension ListConversionInter<T> on List<HSInterColor> {
  List<ColorWithInter> convertToColorWithInter() =>
      map((HSInterColor c) => ColorWithInter(c.toColor(), c)).toList();
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
