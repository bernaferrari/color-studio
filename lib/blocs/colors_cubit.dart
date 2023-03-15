import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../example/mdc/util/color_blind_from_index.dart';
import '../util/color_util.dart';
import '../util/constants.dart';
import 'color_blindness_cubit.dart';

class ColorsState extends Equatable {
  const ColorsState({
    required this.rgbColors,
    required this.hsluvColors,
    required this.rgbColorsWithBlindness,
    required this.locked,
    required this.selected,
    required this.blindnessSelected,
  });

  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, HSLuvColor> hsluvColors;
  final Map<ColorType, Color> rgbColorsWithBlindness;
  final Map<ColorType, bool> locked;
  final ColorType selected;
  final int blindnessSelected;

  @override
  String toString() => 'ColorsState with selected: $selected';

  @override
  List<Object> get props => [
        rgbColors,
        hsluvColors,
        locked,
        rgbColorsWithBlindness,
        selected,
        blindnessSelected
      ];

  ColorsState copyWith({
    Map<ColorType, Color>? rgbColors,
    Map<ColorType, HSLuvColor>? hsluvColors,
    Map<ColorType, Color>? rgbColorsWithBlindness,
    Map<ColorType, bool>? locked,
    ColorType? selected,
    int? blindnessSelected,
  }) {
    return ColorsState(
      rgbColors: rgbColors ?? this.rgbColors,
      hsluvColors: hsluvColors ?? this.hsluvColors,
      rgbColorsWithBlindness:
          rgbColorsWithBlindness ?? this.rgbColorsWithBlindness,
      locked: locked ?? this.locked,
      selected: selected ?? this.selected,
      blindnessSelected: blindnessSelected ?? this.blindnessSelected,
    );
  }
}

class ColorsCubit extends ReplayCubit<ColorsState> {
  ColorsCubit(
      ColorBlindnessCubit _colorBlindnessCubit, ColorsState initialState)
      : super(initialState) {
    limit = 50;
    _blindnessSubscription =
        _colorBlindnessCubit.stream.listen((stateValue) async {
      updateBlindness(stateValue);
    });
  }

  late StreamSubscription _blindnessSubscription;

  @override
  Future<void> close() {
    _blindnessSubscription.cancel();
    return super.close();
  }

  /// This method retrieves a ColorState which is going to be used in super().
  /// The reason is undo/redo support. First ColorCubit value can't be empty.
  static ColorsState initialState(Map<ColorType, Color> initialColors) {
    // final initial = {
    //   ColorType.Primary: initialColors[ColorType.Primary],
    //   ColorType.Secondary: initialColors[ColorType.Secondary],
    //   ColorType.Background:
    //   blendColorWithBackground(initialColors[ColorType.Primary]),
    //   ColorType.Surface: initialColors[ColorType.Surface],
    // };

    final Map<ColorType, Color> initial = {
      ColorType.Primary: initialColors[ColorType.Primary]!,
      ColorType.Secondary: initialColors[ColorType.Secondary]!,
      ColorType.Background: initialColors[ColorType.Background]!,
      ColorType.Surface: initialColors[ColorType.Surface]!,
    };

    final initialLocked = <ColorType, bool>{};

    return ColorsState(
      rgbColors: initial,
      hsluvColors: _convertToHSLuv(initial),
      rgbColorsWithBlindness: initial,
      locked: initialLocked,
      selected: ColorType.Primary,
      blindnessSelected: 0,
    );
  }

  void updateLock({
    required ColorType selectedLock,
    required bool shouldLock,
  }) {
    final allRgb = Map<ColorType, Color>.from(state.rgbColors);
    final lock = Map<ColorType, bool>.from(state.locked);
    lock[selectedLock] = shouldLock;

    ColorType currentSelected = state.selected;

    // Background needs to call [findColor] before Surface does, else
    // Surface will receive the previous Background color.
    for (var key in [
      ColorType.Background,
      ColorType.Surface,
      ColorType.Secondary,
    ]) {
      // if it is null, Dart throws an exception
      if (lock[key] == true) {
        final updatedColor = _findColor(allRgb, key);
        allRgb[key] = updatedColor;
        // When the one selected is locked, select primary (which can't be locked).
        if (currentSelected == key) {
          currentSelected = ColorType.Primary;
        }
      }
    }

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: _convertToHSLuv(allRgb),
        rgbColorsWithBlindness: _getBlindness(allRgb, state.blindnessSelected),
        locked: lock,
        selected: currentSelected,
      ),
    );
  }

  void updateColor({
    ColorType? selected,
    Color? rgbColor,
    HSLuvColor? hsLuvColor,
  }) {
    assert(rgbColor != null || hsLuvColor != null);

    final selectedLocal = selected ?? state.selected;

    final allLuv = Map<ColorType, HSLuvColor>.from(state.hsluvColors);
    final allRgb = Map<ColorType, Color>.from(state.rgbColors);

    if (rgbColor != null && hsLuvColor != null) {
      allLuv[selectedLocal] = hsLuvColor;
      allRgb[selectedLocal] = rgbColor;
    } else if (rgbColor != null) {
      allLuv[selectedLocal] = HSLuvColor.fromColor(rgbColor);
      allRgb[selectedLocal] = rgbColor;
    } else {
      allLuv[selectedLocal] = hsLuvColor!;
      allRgb[selectedLocal] = hsLuvColor.toColor();
    }

    _updateLocked(state, allRgb);

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: allLuv,
        rgbColorsWithBlindness: _getBlindness(
          allRgb,
          state.blindnessSelected,
        ),
        selected: selectedLocal,
      ),
    );
  }

  void updateRgbColor({ColorType? selected, required Color rgbColor}) {
    final selectedLocal = selected ?? state.selected;

    final allRgb = Map<ColorType, Color>.from(state.rgbColors);
    allRgb[selectedLocal] = rgbColor;

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: _convertToHSLuv(allRgb),
        rgbColorsWithBlindness: _getBlindness(
          allRgb,
          state.blindnessSelected,
        ),
        selected: selectedLocal,
      ),
    );
  }

  void updateBlindness(int blindnessSelected) {
    emit(
      state.copyWith(
        rgbColorsWithBlindness: _getBlindness(
          state.rgbColors,
          blindnessSelected,
        ),
        blindnessSelected: blindnessSelected,
      ),
    );
  }

  void updateSelected(ColorType selection) {
    emit(
      state.copyWith(selected: selection),
    );
  }

  // todo add a settings bloc that retrieve the preference shuffle and already shuffles.
  void updateAllColors({
    bool ignoreLock = false,
    required Map<ColorType, Color> colors,
  }) {
    final allRgb = Map<ColorType, Color>.from(state.rgbColors);

    allRgb.forEach((title, _) {
      if (state.locked[title] != true || ignoreLock) {
        allRgb[title] = colors[title]!;
      }
    });

    _updateLocked(state, allRgb);

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: _convertToHSLuv(allRgb),
        rgbColorsWithBlindness: _getBlindness(allRgb, state.blindnessSelected),
      ),
    );
  }

  void fromTemplate({required List<Color> colors}) {
    final allRgb = Map<ColorType, Color>.from(state.rgbColors);

    // Update Primary with colors[0]
    allRgb[ColorType.Primary] = colors[0];

    // Update Background with colors[1]
    allRgb[ColorType.Background] = colors[1];

    // Automatically retrieve Secondary and Surface
    allRgb[ColorType.Secondary] = _findColor(allRgb, ColorType.Secondary);
    allRgb[ColorType.Surface] = _findColor(allRgb, ColorType.Surface);

    final lock = Map<ColorType, bool>.from(state.locked);

    // If Background was locked, unlock it.
    if (lock[ColorType.Background] == true) {
      lock[ColorType.Background] = false;
    }

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: _convertToHSLuv(allRgb),
        rgbColorsWithBlindness: _getBlindness(
          allRgb,
          state.blindnessSelected,
        ),
        locked: lock,
      ),
    );
  }

  /// update the color of the locked ones.
  void _updateLocked(ColorsState state, Map<ColorType, Color> allRgb) {
    for (var key in state.locked.keys) {
      if (state.locked[key]!) {
        allRgb[key] = _findColor(allRgb, key);
      }
    }
  }

  Color _findColor(Map<ColorType, Color> mappedList, ColorType category) {
    if (category == ColorType.Background) {
      return blendColorWithBackground(mappedList[ColorType.Primary]!);
    } else if (category == ColorType.Surface) {
      final luv = HSLuvColor.fromColor(mappedList[ColorType.Background]!);
      return luv.withLightness(luv.lightness + 5).toColor();
    } else if (category == ColorType.Secondary) {
      // use HSV because we want imperfection.
      // HSLuv is going to have the same contrast.
      final hsv = HSVColor.fromColor(mappedList[ColorType.Primary]!);
      return hsv.withHue((hsv.hue + 90) % 360).toColor();
    } else {
      throw Exception("Unsupported category in _findColor from ColorsCubit");
    }
  }

  static Map<ColorType, HSLuvColor> _convertToHSLuv(
    Map<ColorType, Color> updatableMap,
  ) {
    final luvMap = <ColorType, HSLuvColor>{};

    for (var key in updatableMap.keys) {
      luvMap[key] = HSLuvColor.fromColor(updatableMap[key]!);
    }

    return luvMap;
  }

  Map<ColorType, Color> _getBlindness(
    Map<ColorType, Color> updatableMap,
    int index,
  ) {
    if (index == 0) {
      return updatableMap;
    }

    final blindMap = Map<ColorType, Color>.from(updatableMap);
    for (var key in blindMap.keys) {
      blindMap[key] = getColorBlindFromIndex(blindMap[key]!, index)!.color;
    }

    return blindMap;
  }
}
