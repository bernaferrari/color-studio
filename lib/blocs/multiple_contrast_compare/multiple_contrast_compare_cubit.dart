import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:colorstudio/example/util/calculate_contrast.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../blocs.dart';
import 'rgb_hsluv_tuple.dart';

class MultipleContrastCompareCubit extends Cubit<MultipleColorCompareState> {
  MultipleContrastCompareCubit(MdcSelectedBloc _mdcSelectedBloc)
      : super(MultipleColorCompareState()) {
    if (_mdcSelectedBloc.state is MDCLoadedState) {
      final value = _mdcSelectedBloc.state as MDCLoadedState;
      set(
        rgbColors: value.rgbColors,
        hsluvColors: value.hsluvColors,
        locked: value.locked,
      );
    }
    _mdcSubscription = _mdcSelectedBloc.listen((stateValue) async {
      if (stateValue is MDCLoadedState) {
        set(
          rgbColors: stateValue.rgbColors,
          hsluvColors: stateValue.hsluvColors,
          locked: stateValue.locked,
        );
      }
    });
  }

  StreamSubscription _mdcSubscription;

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
    Map<ColorType, Color> rgbColors,
    Map<ColorType, HSLuvColor> hsluvColors,
    Map locked,
    ColorType selectedKey,
  }) {
    final colorsCompared = <ColorType, ColorCompareContrast>{};
    final _selectedKey = selectedKey ?? state.selectedKey;

    for (var key in rgbColors.keys) {
      if (key == _selectedKey) {
        colorsCompared[key] = ColorCompareContrast.withoutRange(
          rgbColor: rgbColors[key],
          hsluvColor: hsluvColors[key],
          name: key,
        );
        continue;
      }

      final colorsRange = <RgbHSLuvTupleWithContrast>[];
      for (int i = -10; i < 15; i += 5) {
        final luv = hsluvColors[key];

        // if lightness becomes 0 or 100 the hue value might be lost
        // because app is always converting HSLuv to RGB and vice-versa.
        final updatedLuv =
            luv.withLightness(interval(luv.lightness + i, 5.0, 95.0));

        colorsRange.add(
          RgbHSLuvTupleWithContrast(
            rgbColor: updatedLuv.toColor(),
            hsluvColor: updatedLuv,
            againstColor: rgbColors[_selectedKey],
          ),
        );
      }

      colorsCompared[key] = ColorCompareContrast(
        rgbColor: rgbColors[key],
        hsluvColor: hsluvColors[key],
        name: key,
        colorsRange: colorsRange,
        againstColor: rgbColors[_selectedKey],
      );
    }

    emit(
      MultipleColorCompareState(
        colorsCompared: colorsCompared,
        locked: state.locked,
        originalRgb: rgbColors,
        originalHsluv: hsluvColors,
        selectedKey: _selectedKey,
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

  final Map<ColorType, ColorCompareContrast> colorsCompared;
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
    @required this.rgbColor,
    @required this.hsluvColor,
    @required this.name,
    @required this.colorsRange,
    @required Color againstColor,
  }) : contrast = calculateContrast(rgbColor, againstColor);

  const ColorCompareContrast.withoutRange({
    @required this.rgbColor,
    @required this.hsluvColor,
    @required this.name,
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
