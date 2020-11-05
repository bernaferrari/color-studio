import 'dart:ui';

import 'package:colorstudio/example/util/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:hsluv/hsluvcolor.dart';

abstract class MdcSelectedState extends Equatable {
  const MdcSelectedState();
}

class MDCInitialState extends MdcSelectedState {
  const MDCInitialState();

  @override
  List<Object> get props => [];
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

  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, HSLuvColor> hsluvColors;
  final Map<ColorType, Color> rgbColorsWithBlindness;
  final Map<ColorType, bool> locked;
  final ColorType selected;
  final int blindnessSelected;

  @override
  String toString() => 'MDCLoadedState state with selected: $selected';

  @override
  List<Object> get props => [
        rgbColors,
        hsluvColors,
        locked,
        rgbColorsWithBlindness,
        selected,
        blindnessSelected
      ];
}
