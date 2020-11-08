import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../example/mdc/util/elevation_overlay.dart';
import '../../example/util/calculate_contrast.dart';
import '../../example/util/color_util.dart';
import '../../example/util/constants.dart';
import '../mdc_selected/mdc_selected.dart';
import '../mdc_selected/mdc_selected_bloc.dart';

// enum ContrastCardType {
//   Primary,
//   Secondary,
//   Background,
//   Surface,
// }

class ContrastRatioCubit extends Cubit<ContrastRatioState> {
  ContrastRatioCubit(MdcSelectedBloc _mdcSelectedBloc)
      : super(ContrastRatioState()) {
    _mdcSubscription = _mdcSelectedBloc.listen((stateValue) async {
      print("stateValue was changed $stateValue");
      if (stateValue is MDCLoadedState) {
        set(rgbColorsWithBlindness: stateValue.rgbColorsWithBlindness);
      }
    });
  }

  StreamSubscription _mdcSubscription;

  @override
  Future<void> close() {
    _mdcSubscription.cancel();
    return super.close();
  }

  void set({
    Map<ColorType, Color> rgbColorsWithBlindness,
    ColorType selectedColorType,
  }) {
    final rgb = rgbColorsWithBlindness ?? state.rgbColorsWithBlindness;

    final _contrastSectionType =
        selectedColorType ?? state.selectedColorType;

    if (_contrastSectionType == ColorType.Primary || _contrastSectionType == ColorType.Secondary) {
      emit(
        ContrastRatioState(
          contrastValues: [
            calculateContrast(
              rgb[_contrastSectionType],
              rgb[ColorType.Background],
            ),
            calculateContrast(
              rgb[_contrastSectionType],
              rgb[ColorType.Surface],
            ),
          ],
          selectedColorType: _contrastSectionType,
          rgbColorsWithBlindness: rgb,
        ),
      );
    } else if (_contrastSectionType == ColorType.Background) {
      // when secondary, compare against background and surface
      emit(
        ContrastRatioState(
          contrastValues: [
            calculateContrast(
              rgb[ColorType.Primary],
              rgb[ColorType.Background],
            ),
            calculateContrast(
              rgb[ColorType.Secondary],
              rgb[ColorType.Background],
            ),
          ],
          selectedColorType: _contrastSectionType,
          rgbColorsWithBlindness: rgb,
        ),
      );
    } else if (_contrastSectionType == ColorType.Surface) {
      // when secondary, compare against background and surface
      emit(
        ContrastRatioState(
          contrastValues: [
            calculateContrast(
              rgb[ColorType.Primary],
              rgb[ColorType.Surface],
            ),
            calculateContrast(
              rgb[ColorType.Secondary],
              rgb[ColorType.Surface],
            ),
          ],
          selectedColorType: _contrastSectionType,
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
                  rgb[ColorType.Surface],
                  elevationEntries[i].overlay,
                ),
                rgb[ColorType.Primary],
              ),
          ],
          selectedColorType: _contrastSectionType,
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
