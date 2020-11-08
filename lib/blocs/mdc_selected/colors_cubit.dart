import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../example/mdc/util/color_blind_from_index.dart';
import '../../example/util/color_util.dart';
import '../../example/util/constants.dart';
import '../color_blind/color_blindness_cubit.dart';
import 'mdc_selected.dart';

class ColorsState extends Equatable {
  const ColorsState({
    @required this.rgbColors,
    @required this.hsluvColors,
    @required this.rgbColorsWithBlindness,
    @required this.locked,
    @required this.selected,
    @required this.blindnessSelected,
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
    Map<ColorType, Color> rgbColors,
    Map<ColorType, HSLuvColor> hsluvColors,
    Map<ColorType, Color> rgbColorsWithBlindness,
    Map<ColorType, bool> locked,
    ColorType selected,
    int blindnessSelected,
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

class ColorsCubit extends Cubit<ColorsState> {
  ColorsCubit(ColorBlindnessCubit _colorBlindnessCubit)
      : assert(_colorBlindnessCubit != null),
        super(
          ColorsState(
            rgbColors: const {},
            hsluvColors: const {},
            rgbColorsWithBlindness: const {},
            locked: const {},
            selected: ColorType.Primary,
            blindnessSelected: 0,
          ),
        ) {
    _blindnessSubscription = _colorBlindnessCubit.listen((stateValue) async {
      updateBlindness(stateValue);
    });
  }

  StreamSubscription _blindnessSubscription;

  @override
  Future<void> close() {
    _blindnessSubscription.cancel();
    return super.close();
  }

  void initialState(Map<ColorType, Color> initialColors) {
    final initial = {
      ColorType.Primary: initialColors[ColorType.Primary],
      ColorType.Secondary: initialColors[ColorType.Secondary],
      ColorType.Background:
          blendColorWithBackground(initialColors[ColorType.Primary]),
      ColorType.Surface: initialColors[ColorType.Surface],
    };

    final initialLocked = <ColorType, bool>{};

    emit(
      ColorsState(
        rgbColors: initial,
        hsluvColors: convertToHSLuv(initial),
        rgbColorsWithBlindness: initial,
        locked: initialLocked,
        selected: ColorType.Primary,
        blindnessSelected: 0,
      ),
    );
  }

  void updateLock({
    @required ColorType selectedLock,
    @required bool shouldLock,
  }) {
    final allRgb = Map<ColorType, Color>.from(state.rgbColors);
    final lock = Map<ColorType, bool>.from(state.locked);
    lock[selectedLock] = shouldLock;

    // Background needs to call [findColor] before Surface does, else
    // Surface will receive the previous Background color.
    [
      ColorType.Background,
      ColorType.Surface,
      ColorType.Secondary,
    ].forEach((key) {
      // if it is null, Dart throws an exception
      if (lock[key] == true) {
        final updatedColor = findColor(allRgb, key);
        allRgb[key] = updatedColor;
      }
    });

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: convertToHSLuv(allRgb),
        rgbColorsWithBlindness: getBlindness(allRgb, state.blindnessSelected),
        locked: lock,
      ),
    );
  }

  void updateColor({
    @required ColorType selected,
    Color rgbColor,
    HSLuvColor hsLuvColor,
  }) {
    assert(rgbColor != null || hsLuvColor != null);

    final allLuv = Map<ColorType, HSLuvColor>.from(state.hsluvColors);
    final allRgb = Map<ColorType, Color>.from(state.rgbColors);

    if (rgbColor != null && hsLuvColor != null) {
      allLuv[selected] = hsLuvColor;
      allRgb[selected] = rgbColor;
    } else if (rgbColor != null) {
      allLuv[selected] = HSLuvColor.fromColor(rgbColor);
      allRgb[selected] = rgbColor;
    } else {
      allLuv[selected] = hsLuvColor;
      allRgb[selected] = hsLuvColor.toColor();
    }

    updateLocked(state, allRgb);

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: allLuv,
        rgbColorsWithBlindness: getBlindness(
          allRgb,
          state.blindnessSelected,
        ),
        selected: selected,
      ),
    );
  }

  void loadColor({ColorType selected, @required Color rgbColor}) {
    final _selected = selected ?? state.selected;

    final Map<ColorType, Color> allRgb = Map.from(state.rgbColors);
    allRgb[_selected] = rgbColor;

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: convertToHSLuv(allRgb),
        rgbColorsWithBlindness: getBlindness(
          allRgb,
          state.blindnessSelected,
        ),
        selected: _selected,
      ),
    );
  }

  void updateBlindness(int blindnessSelected) {
    emit(
      state.copyWith(
        rgbColorsWithBlindness: getBlindness(
          state.rgbColors,
          blindnessSelected,
        ),
        blindnessSelected: blindnessSelected,
      ),
    );
  }

  // todo add a settings bloc that retrieve the preference shuffle and already shuffles.
  void updateAllColors({bool ignoreLock, Map<ColorType, Color> colors}) {
    final Map<ColorType, Color> allRgb = Map.from(state.rgbColors);

    allRgb.forEach((title, _) {
      if (state.locked[title] != true || ignoreLock) {
        allRgb[title] = colors[title];
      }
    });

    updateLocked(state, allRgb);

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: convertToHSLuv(allRgb),
        rgbColorsWithBlindness: getBlindness(allRgb, state.blindnessSelected),
      ),
    );
  }

  void fromTemplate(List<Color> colors) {
    final currentState = state as MDCLoadedState;

    final allRgb = Map<ColorType, Color>.from(currentState.rgbColors);

    // Update Primary with colors[0]
    allRgb[ColorType.Primary] = colors[0];

    // Update Background with colors[1]
    allRgb[ColorType.Background] = colors[1];

    // Automatically retrieve Secondary and Surface
    allRgb[ColorType.Secondary] = findColor(allRgb, ColorType.Secondary);
    allRgb[ColorType.Surface] = findColor(allRgb, ColorType.Surface);

    final lock = Map<ColorType, bool>.from(currentState.locked);

    // If Background was locked, unlock it.
    if (lock[ColorType.Background] == true) {
      lock[ColorType.Background] = false;
    }

    emit(
      state.copyWith(
        rgbColors: allRgb,
        hsluvColors: convertToHSLuv(allRgb),
        rgbColorsWithBlindness: getBlindness(
          allRgb,
          currentState.blindnessSelected,
        ),
        locked: lock,
      ),
    );
  }

  /// update the color of the locked ones.
  void updateLocked(ColorsState state, Map<ColorType, Color> allRgb) {
    for (var key in state.locked.keys) {
      if (state.locked[key]) {
        allRgb[key] = findColor(allRgb, key);
      }
    }
  }

  Color findColor(Map<ColorType, Color> mappedList, ColorType category) {
    if (category == ColorType.Background) {
      return blendColorWithBackground(mappedList[ColorType.Primary]);
    } else if (category == ColorType.Surface) {
      final luv = HSLuvColor.fromColor(mappedList[ColorType.Background]);
      return luv.withLightness(luv.lightness + 5).toColor();
    } else if (category == ColorType.Secondary) {
      final luv = HSLuvColor.fromColor(mappedList[ColorType.Primary]);
      return luv.withHue((luv.lightness + 90) % 360).toColor();
    }

    return const Color(0xffffffff);
  }

  Map<ColorType, HSLuvColor> convertToHSLuv(
    Map<ColorType, Color> updatableMap,
  ) {
    final luvMap = <ColorType, HSLuvColor>{};

    for (var key in updatableMap.keys) {
      luvMap[key] = HSLuvColor.fromColor(updatableMap[key]);
    }

    return luvMap;
  }

  Map<ColorType, Color> getBlindness(
      Map<ColorType, Color> updatableMap, int index) {
    if (index == 0) {
      return updatableMap;
    }

    final Map<ColorType, Color> blindMap = Map.from(updatableMap);
    for (var key in blindMap.keys) {
      blindMap[key] = getColorBlindFromIndex(blindMap[key], index).color;
    }

    return blindMap;
  }
}
