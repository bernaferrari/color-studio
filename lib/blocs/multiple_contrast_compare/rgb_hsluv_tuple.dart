import 'dart:ui';

import 'package:colorstudio/example/util/calculate_contrast.dart';
import 'package:equatable/equatable.dart';
import 'package:hsluv/hsluvcolor.dart';

class RgbHSLuvTuple {
  RgbHSLuvTuple(this.rgbColor, this.hsluvColor);

  final Color rgbColor;
  final HSLuvColor hsluvColor;
}

class RgbHSLuvTupleWithContrast extends Equatable {
  RgbHSLuvTupleWithContrast(
      {this.rgbColor, this.hsluvColor, Color againstColor})
      : contrast = calculateContrast(rgbColor, againstColor);

  final Color rgbColor;
  final HSLuvColor hsluvColor;
  final double contrast;

  @override
  List<Object> get props => [rgbColor, hsluvColor, contrast];
}
