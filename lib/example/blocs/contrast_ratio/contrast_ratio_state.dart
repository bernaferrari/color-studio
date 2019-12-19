import 'dart:ui';

import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:equatable/equatable.dart';

abstract class ContrastRatioState extends Equatable {
  const ContrastRatioState();
}

class InitialContrastRatioState extends ContrastRatioState {
  @override
  List<Object> get props => [];
}

class ContrastRatioSuccess extends ContrastRatioState {
  const ContrastRatioSuccess({
    this.contrastValues,
    this.elevationValues,
  });

  final List<double> contrastValues;
  final List<ColorContrast> elevationValues;

  @override
  String toString() =>
      'ContrastRatioSuccess: $contrastValues';

  @override
  List<Object> get props => [contrastValues, elevationValues];
}

class ColorContrast {
  ColorContrast(this.color, Color color2)
      : contrast = calculateContrast(color, color2);

  final Color color;
  final double contrast;
}
