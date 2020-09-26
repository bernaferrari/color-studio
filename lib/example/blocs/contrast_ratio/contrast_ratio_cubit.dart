import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:colorstudio/example/blocs/mdc_selected/mdc_selected.dart';
import 'package:colorstudio/example/blocs/mdc_selected/mdc_selected_bloc.dart';
import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:colorstudio/example/mdc/util/elevation_overlay.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:equatable/equatable.dart';

class ContrastRatioCubit extends Cubit<ContrastRatioState> {
  ContrastRatioCubit(MdcSelectedBloc _mdcSelectedBloc)
      : super(ContrastRatioState()) {
    _mdcSubscription = _mdcSelectedBloc.listen((stateValue) async {
      if (stateValue is MDCLoadedState) {
        set(stateValue.rgbColorsWithBlindness);
      }
    });
  }

  StreamSubscription _mdcSubscription;

  @override
  Future<Function> close() {
    _mdcSubscription.cancel();
    return super.close();
  }

  void set(Map<String, Color> rgbColorsWithBlindness) {
    final rgb = rgbColorsWithBlindness;

    emit(
      ContrastRatioState(
        contrastValues: [
          calculateContrast(rgb[kPrimary], rgb[kBackground]),
          calculateContrast(rgb[kPrimary], rgb[kSurface]),
          calculateContrast(rgb[kBackground], rgb[kSurface]),
        ],
        elevationValues: [
          for (int i = 0; i < elevationEntriesList.length; i++)
            ColorContrast(
              compositeColors(
                const Color(0xffffffff),
                rgb[kSurface],
                elevationEntries[i].overlay,
              ),
              rgb[kPrimary],
            ),
        ],
      ),
    );
  }
}

class ContrastRatioState extends Equatable {
  const ContrastRatioState({
    this.contrastValues = const [],
    this.elevationValues = const [],
  });

  final List<double> contrastValues;
  final List<ColorContrast> elevationValues;

  @override
  String toString() => 'ContrastRatioSuccess: $contrastValues';

  @override
  List<Object> get props => [contrastValues, elevationValues];
}

class ColorContrast {
  ColorContrast(this.color, Color color2)
      : contrast = calculateContrast(color, color2);

  final Color color;
  final double contrast;
}
