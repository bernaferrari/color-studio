import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../util/calculate_contrast.dart';
import '../../util/color_util.dart';
import '../../util/constants.dart';
import '../blocs.dart';
import 'rgb_hsluv_tuple.dart';

class MultipleContrastCompareCubit extends Cubit<MultipleColorCompareState> {
  MultipleContrastCompareCubit(ColorsCubit colorsCubit)
      : super(const MultipleColorCompareState()) {
    set(
      rgbColors: colorsCubit.state.rgbColors,
      hsluvColors: colorsCubit.state.hsluvColors,
      locked: colorsCubit.state.locked,
    );

    _mdcSubscription = colorsCubit.stream.listen((stateValue) async {
      set(
        rgbColors: stateValue.rgbColors,
        hsluvColors: stateValue.hsluvColors,
        locked: stateValue.locked,
      );
    });
  }

  late StreamSubscription _mdcSubscription;

  @override
  Future<void> close() {
    _mdcSubscription.cancel();
    return super.close();
  }

  void updateSelectedKey(ColorType selectedKey) {
    set(
      rgbColors: state.originalRgb,
      hsluvColors: state.originalHsluv,
      locked: state.locked,
      selectedKey: selectedKey,
    );
  }

  void set({
    required Map<ColorType, Color> rgbColors,
    Map<ColorType, HSLuvColor>? hsluvColors,
    Map? locked,
    ColorType? selectedKey,
  }) {
    final colorsCompared = <ColorType, ColorCompareContrast>{};
    final ColorType selectedKeyLocal = selectedKey ?? state.selectedKey;

    for (var key in rgbColors.keys) {
      if (key == selectedKeyLocal) {
        colorsCompared[key] = ColorCompareContrast.withoutRange(
          rgbColor: rgbColors[key]!,
          hsluvColor: hsluvColors![key]!,
          name: key,
        );
        continue;
      }

      final colorsRange = <RgbHSLuvTupleWithContrast>[];
      for (var i = -10; i < 15; i += 5) {
        final luv = hsluvColors![key]!;

        // if lightness becomes 0 or 100 the hue value might be lost
        // because app is always converting HSLuv to RGB and vice-versa.
        final updatedLuv =
            luv.withLightness(interval(luv.lightness + i, 5.0, 95.0));

        colorsRange.add(
          RgbHSLuvTupleWithContrast(
            rgbColor: updatedLuv.toColor(),
            hsluvColor: updatedLuv,
            againstColor: rgbColors[selectedKeyLocal]!,
          ),
        );
      }

      colorsCompared[key] = ColorCompareContrast(
        rgbColor: rgbColors[key]!,
        hsluvColor: hsluvColors![key]!,
        name: key,
        colorsRange: colorsRange,
        againstColor: rgbColors[selectedKeyLocal]!,
      );
    }

    emit(
      MultipleColorCompareState(
        colorsCompared: colorsCompared,
        locked: state.locked,
        originalRgb: rgbColors,
        originalHsluv: hsluvColors!,
        selectedKey: selectedKeyLocal,
      ),
    );
  }
}

class MultipleColorCompareState extends Equatable {
  const MultipleColorCompareState({
    this.colorsCompared = const {},
    this.originalRgb = const {},
    this.originalHsluv = const {},
    this.locked = const {},
    this.selectedKey = ColorType.Primary,
  });

  final Map<ColorType, Color> originalRgb;
  final Map<ColorType, HSLuvColor> originalHsluv;

  final Map<ColorType /*!*/, ColorCompareContrast> colorsCompared;
  final Map<ColorType, bool> locked;
  final ColorType selectedKey;

  @override
  String toString() =>
      'MultipleColorCompareState($colorsCompared, $selectedKey $locked)';

  @override
  List<Object> get props => [colorsCompared, selectedKey, locked];
}

class ColorCompareContrast extends Equatable {
  ColorCompareContrast({
    required this.rgbColor,
    required this.hsluvColor,
    required this.name,
    required this.colorsRange,
    required Color againstColor,
  }) : contrast = calculateContrast(rgbColor, againstColor);

  const ColorCompareContrast.withoutRange({
    required this.rgbColor,
    required this.hsluvColor,
    required this.name,
    this.colorsRange = const [],
    this.contrast = 0,
  });

  final ColorType name;
  final Color rgbColor;
  final HSLuvColor hsluvColor;
  final double contrast;
  final List<RgbHSLuvTupleWithContrast> colorsRange;

  @override
  String toString() => 'ColorCompareContrast($name: $rgbColor)';

  @override
  List<Object> get props => [rgbColor, name, contrast, colorsRange];
}
