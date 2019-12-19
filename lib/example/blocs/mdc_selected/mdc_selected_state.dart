import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:hsluv/hsluvcolor.dart';

abstract class MdcSelectedState extends Equatable {
  const MdcSelectedState();
}

class MDCLoadedState extends MdcSelectedState {
  const MDCLoadedState(
    this.rgbColors,
    this.hsluvColors,
    this.rgbColorsWithBlindness,
    this.locked,
    this.selected,
    this.blindnessSelected,
  );

  final Map<String, Color> rgbColors;
  final Map<String, HSLuvColor> hsluvColors;
  final Map<String, Color> rgbColorsWithBlindness;
  final Map<String, bool> locked;
  final String selected;
  final int blindnessSelected;

  @override
  String toString() => 'MDCLoadedState state with selected: $selected';

  @override
  List<Object> get props =>
      [rgbColors, hsluvColors, locked, rgbColorsWithBlindness, selected, blindnessSelected];
}
