import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../util/calculate_contrast.dart';

class RgbHSLuvTuple {
  RgbHSLuvTuple(this.rgbColor, this.hsluvColor);

  final Color rgbColor;
  final HSLuvColor hsluvColor;
}

class RgbHSLuvTupleWithContrast extends Equatable {
  RgbHSLuvTupleWithContrast({
    required this.rgbColor,
    required this.hsluvColor,
    required Color againstColor,
  }) : contrast = calculateContrast(rgbColor, againstColor);

  final Color rgbColor;
  final HSLuvColor hsluvColor;
  final double contrast;

  @override
  List<Object?> get props => [rgbColor, hsluvColor, contrast];
}
