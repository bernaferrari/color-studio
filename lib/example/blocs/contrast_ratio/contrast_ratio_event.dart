import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ContrastRatioEvent extends Equatable {
  const ContrastRatioEvent();
}

class ContrastRatioUpdated extends ContrastRatioEvent {
  const ContrastRatioUpdated({
    @required this.rgbColorsWithBlindness,
  });

  final Map<String, Color> rgbColorsWithBlindness;

  @override
  String toString() =>
      "ContrastRatioUpdated... $rgbColorsWithBlindness";

  @override
  List<Object> get props => [rgbColorsWithBlindness];
}
