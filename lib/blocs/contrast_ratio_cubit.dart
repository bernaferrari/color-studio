import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../example/mdc/util/elevation_overlay.dart';
import '../util/calculate_contrast.dart';
import '../util/color_util.dart';
import '../util/constants.dart';
import 'blocs.dart';

class ContrastRatioCubit extends Cubit<ContrastRatioState> {
  ContrastRatioCubit(ColorsCubit _colorsCubit)
      : super(const ContrastRatioState()) {
    // on first run, listen will not be called because it will already have a value.
    set(
      rgbColorsWithBlindness: _colorsCubit.state.rgbColorsWithBlindness,
      selectedColorType: _colorsCubit.state.selected,
    );

    _mdcSubscription = _colorsCubit.stream.listen((stateValue) async {
      set(
        rgbColorsWithBlindness: stateValue.rgbColorsWithBlindness,
        selectedColorType: stateValue.selected,
      );
    });
  }

  late StreamSubscription _mdcSubscription;

  @override
  Future<void> close() {
    _mdcSubscription.cancel();
    return super.close();
  }

  void set({
    Map<ColorType, Color>? rgbColorsWithBlindness,
    ColorType? selectedColorType,
  }) {
    // ignore when there was no change.
    if (rgbColorsWithBlindness == state.rgbColorsWithBlindness &&
        selectedColorType == state.selectedColorType) {
      return;
    }

    final rgb = rgbColorsWithBlindness ?? state.rgbColorsWithBlindness;
    final contrastSectionType = selectedColorType ?? state.selectedColorType;

    if (contrastSectionType == ColorType.Primary ||
        contrastSectionType == ColorType.Secondary) {
      emit(
        ContrastRatioState(
          contrastValues: [
            calculateContrast(
              rgb[contrastSectionType]!,
              rgb[ColorType.Background]!,
            ),
            calculateContrast(
              rgb[contrastSectionType]!,
              rgb[ColorType.Surface]!,
            ),
          ],
          selectedColorType: contrastSectionType,
          rgbColorsWithBlindness: rgb,
        ),
      );
    } else if (contrastSectionType == ColorType.Background) {
      // when secondary, compare against background and surface
      emit(
        ContrastRatioState(
          contrastValues: [
            calculateContrast(
              rgb[ColorType.Primary]!,
              rgb[ColorType.Background]!,
            ),
            calculateContrast(
              rgb[ColorType.Secondary]!,
              rgb[ColorType.Background]!,
            ),
          ],
          selectedColorType: contrastSectionType,
          rgbColorsWithBlindness: rgb,
        ),
      );
    } else if (contrastSectionType == ColorType.Surface) {
      // when secondary, compare against background and surface
      emit(
        ContrastRatioState(
          contrastValues: [
            calculateContrast(
              rgb[ColorType.Primary]!,
              rgb[ColorType.Surface]!,
            ),
            calculateContrast(
              rgb[ColorType.Secondary]!,
              rgb[ColorType.Surface]!,
            ),
          ],
          selectedColorType: contrastSectionType,
          rgbColorsWithBlindness: rgb,
        ),
      );
    } else {
      // when elevation, retrieve all the steps.
      emit(
        ContrastRatioState(
          elevationValues: [
            for (int i = 0; i < elevationEntriesList.length; i++)
              ColorContrast(
                compositeColors(
                  const Color(0xffffffff),
                  rgb[ColorType.Surface]!,
                  elevationEntries[i].overlay,
                ),
                rgb[ColorType.Primary]!,
              ),
          ],
          selectedColorType: contrastSectionType,
          rgbColorsWithBlindness: rgb,
        ),
      );
    }
  }
}

class ContrastRatioState extends Equatable {
  const ContrastRatioState({
    this.contrastValues = const [],
    this.elevationValues = const [],
    this.selectedColorType = ColorType.Primary,
    this.rgbColorsWithBlindness = const {},
  });

  final List<double> contrastValues;
  final List<ColorContrast> elevationValues;
  final ColorType selectedColorType;
  final Map<ColorType, Color> rgbColorsWithBlindness;

  @override
  String toString() =>
      'ContrastRatioState: $selectedColorType $contrastValues $elevationValues';

  @override
  List<Object> get props =>
      [selectedColorType, contrastValues, elevationValues];
}

class ColorContrast {
  ColorContrast(this.color, Color againstColor)
      : contrast = calculateContrast(color, againstColor);

  final Color color;
  final double contrast;
}
